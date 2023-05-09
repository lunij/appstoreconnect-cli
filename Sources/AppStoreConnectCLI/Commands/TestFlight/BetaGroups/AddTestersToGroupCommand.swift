// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct AddTestersToGroupCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "adduser",
        abstract: "Add testers to beta group"
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The bundle ID of an application. (eg. com.example.app)")
    var bundleId: String

    @Argument(help: "Name of TestFlight beta tester group.")
    var groupName: String

    @Argument(help: "Beta testers' email addresses.")
    var emails: [String]

    func validate() throws {
        if emails.isEmpty {
            throw ValidationError("Expected at least one email.")
        }
    }

    func run() async throws {
        let service = try makeService()

        let testerIds = try await emails.asyncMap {
            try await GetBetaTesterOperation(
                service: service,
                options: .init(identifier: .email($0))
            )
            .execute()
            .id
        }

        let app = try await ReadAppOperation(
            service: service,
            options: .init(identifier: .bundleId(bundleId))
        )
        .execute()

        let groupId = try await GetBetaGroupOperation(
            service: service,
            options: .init(appId: app.id, bundleId: bundleId, betaGroupName: groupName)
        )
        .execute()
        .id

        try await AddTesterToGroupOperation(
            service: service,
            options: .init(
                addStrategy: .addTestersToGroup(testerIds: testerIds, groupId: groupId)
            )
        )
        .execute()
    }
}
