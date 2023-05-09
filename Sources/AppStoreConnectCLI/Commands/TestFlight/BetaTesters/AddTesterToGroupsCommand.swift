// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct AddTesterToGroupsCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "addgroup",
        abstract: "Add tester to one or more groups"
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "Beta testers' email address.")
    var email: String

    @Argument(help: "The bundle ID of an application. (eg. com.example.app)")
    var bundleId: String

    @Argument(help: "Name of TestFlight beta tester group.")
    var groupNames: [String]

    func validate() throws {
        if groupNames.isEmpty {
            throw ValidationError("Expected at least one group name.")
        }
    }

    func run() async throws {
        let service = try makeService()

        let testerId = try await GetBetaTesterOperation(
            service: service,
            options: .init(identifier: .email(email))
        )
        .execute()
        .id

        let app = try await ReadAppOperation(
            service: service,
            options: .init(identifier: .bundleId(bundleId))
        )
        .execute()

        let groupIds = try await groupNames.asyncMap {
            try await GetBetaGroupOperation(
                service: service,
                options: .init(appId: app.id, bundleId: bundleId, betaGroupName: $0)
            )
            .execute()
            .id
        }

        try await AddTesterToGroupOperation(
            service: service,
            options: .init(addStrategy: .addTesterToGroups(testerId: testerId, groupIds: groupIds))
        )
        .execute()
    }
}
