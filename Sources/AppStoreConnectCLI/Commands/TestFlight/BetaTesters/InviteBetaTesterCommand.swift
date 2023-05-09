// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct InviteBetaTesterCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "invite",
        abstract: "Invite a beta tester and assign them to one or more groups"
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The beta tester's email address, used for sending beta testing invitations.")
    var email: String

    @Argument(help: "The beta tester's first name.")
    var firstName: String?

    @Argument(help: "The beta tester's last name.")
    var lastName: String?

    @Argument(help: "The bundle ID of an application. (eg. com.example.app)")
    var bundleId: String

    @Option(
        parsing: .upToNextOption,
        help: "Names of TestFlight beta tester group that the tester will be assigned to."
    )
    var groups: [String]

    func validate() throws {
        if groups.isEmpty {
            throw ValidationError("Invalid input, you must provide at least one group name.")
        }
    }

    func run() async throws {
        let service = try makeService()
        let betaTester = try await InviteTesterOperation(
            service: service,
            options: .init(
                firstName: firstName,
                lastName: lastName,
                email: email,
                identifers: .bundleIdWithGroupNames(bundleId: bundleId, groupNames: groups)
            )
        )
        .execute()

        try BetaTester(betaTester)
            .render(options: common.outputOptions)
    }
}
