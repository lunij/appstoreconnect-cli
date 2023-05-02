// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik
import struct Model.User

struct ListUsersCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "list",
        abstract: "Get a list of the users on your team."
    )

    @OptionGroup()
    var common: CommonOptions

    @Option(help: "Limit the number visible apps to return (maximum 50).")
    var limitVisibleApps: Int?

    @Option(help: "Limit the number of users to return (maximum 200).")
    var limitUsers: Int?

    @Option(
        parsing: .unconditional,
        help: ArgumentHelp(
            "Sort the results using one or more of the following values: \(ListUsersV1.Sort.allValueStringsFormatted)",
            discussion: "The `-` prefix indicates descending order."
        ),
        transform: { $0.components(separatedBy: ",").compactMap(ListUsersV1.Sort.init(argument:)) }
    )
    var sorts: [ListUsersV1.Sort] = []

    @Option(
        parsing: .upToNextOption,
        help: "Filter the results by the specified username.",
        transform: { $0.lowercased() }
    )
    var filterUsername: [String] = []

    @Option(
        parsing: .upToNextOption,
        help: "Filter the results by specified roles: \(ListUsersV1.Filter.Roles.allValueStringsFormatted)"
    )
    var filterRoles: [ListUsersV1.Filter.Roles] = []

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(discussion:
            """
            Filter the results by the app(s) resources ids or bundle ids visible to each user.
            Users with access to all apps will always be included.
            """
        ),
        transform: AppLookupIdentifier.init
    )
    var filterVisibleApps: [AppLookupIdentifier] = []

    @Flag(help: "Include visible apps in results.")
    var includeVisibleApps = false
    
    public func run() async throws {
        let service = try makeService()

        let appIds = try await filterVisibleApps.asyncMap { identifier -> String in
            switch identifier {
            case .appId(let appid):
                return appid
            case .bundleId(let bundleId):
                return try await ReadAppOperation(service: service, options: .init(identifier: .bundleId(bundleId)))
                    .execute()
                    .id
            }
        }

        try await ListUsersOperation(
            service: service,
            options: .init(
                limitVisibleApps: limitVisibleApps,
                limitUsers: limitUsers,
                filterUsername: filterUsername,
                filterRoles: filterRoles,
                filterVisibleApps: appIds,
                includeVisibleApps: includeVisibleApps,
                sorts: sorts
            )
        )
        .execute()
        .map(Model.User.init)
        .render(options: common.outputOptions)
    }
}

extension ListUsersV1.Filter.Roles: ExpressibleByArgument {}

extension ListUsersV1.Sort: ExpressibleByArgument {}
