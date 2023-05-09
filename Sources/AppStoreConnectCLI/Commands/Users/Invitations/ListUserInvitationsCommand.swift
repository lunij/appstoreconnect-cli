// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct ListUserInvitationsCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "list-invitations",
        abstract: "Get a list of pending invitations to join your team."
    )

    @OptionGroup()
    var common: CommonOptions

    @Option(help: "Limit the number visible apps to return (maximum 50).")
    var limitVisibleApps: Int?

    @Option(parsing: .upToNextOption, help: "Filter the results by the specified username")
    var filterEmail: [String] = []

    @Option(parsing: .upToNextOption, help: "Filter the results by roles: \(UserRole.allValueStringsFormatted)")
    var filterRole: [UserRole] = []

    @Flag(help: "Include visible apps in results.")
    var includeVisibleApps = false

    public func run() async throws {
        let service = try makeService()
        try await ListUserInvitationsOperation(
            service: service,
            options: .init(
                filterEmail: filterEmail,
                filterRole: filterRole,
                includeVisibleApps: includeVisibleApps,
                limitVisibleApps: limitVisibleApps
            )
        )
        .execute()
        .map(UserInvitation.init)
        .render(options: common.outputOptions)
    }
}
