// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_TestFlight

struct ListBetaGroupsCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "list",
        abstract: "List beta groups"
    )

    @OptionGroup()
    var common: CommonOptions

    @OptionGroup()
    var appLookupOptions: AppLookupOptions

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter by beta group name",
            discussion: """
            This filter works on partial matches in a case insensitive fashion, \
            e.g. 'group' will match 'myGroup'
            """,
            valueName: "filter-names"
        )
    )
    var filterNames: [String] = []

    @Option(
        parsing: .unconditional,
        help: ArgumentHelp(
            "Sort the results using one or more of: \(ListBetaGroupsV1.Sort.allValueStringsFormatted).",
            discussion: "The `-` prefix indicates descending order."
        ),
        transform: { $0.components(separatedBy: ",").compactMap(ListBetaGroupsV1.Sort.init(argument:)) }
    )
    var sorts: [ListBetaGroupsV1.Sort] = []

    @Flag(
        help: "Exclude apple store connect internal beta groups."
    )
    var excludeInternal = false

    func run() async throws {
        let service = try makeService()

        var filterAppIds: [String] = []
        var filterBundleIds: [String] = []

        appLookupOptions.filterIdentifiers.forEach { identifier in
            switch identifier {
            case let .appId(filterAppId):
                filterAppIds.append(filterAppId)
            case let .bundleId(filterBundleId):
                filterBundleIds.append(filterBundleId)
            }
        }

        if filterBundleIds.isNotEmpty {
            filterAppIds += try await GetAppsOperation(
                service: service,
                options: .init(bundleIds: filterBundleIds)
            )
            .execute().map(\.id)
        }

        try await ListBetaGroupsOperation(
            service: service,
            options: .init(
                appIds: filterAppIds,
                names: filterNames,
                sorts: sorts,
                excludeInternal: excludeInternal
            )
        )
        .execute()
        .map(BetaGroup.init)
        .render(options: common.outputOptions)
    }
}

extension ListBetaGroupsV1.Sort: ExpressibleByArgument {}
