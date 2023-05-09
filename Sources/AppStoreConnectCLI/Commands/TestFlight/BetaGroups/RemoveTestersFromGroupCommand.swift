// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct RemoveTestersFromGroupCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "removeuser",
        abstract: "Remove beta testers from a beta group"
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "Name of TestFlight beta tester group")
    var groupName: String

    @Argument(help: "Beta testers' email addresses")
    var emails: [String]

    func run() async throws {
        let service = try makeService()

        let groupId = try await GetBetaGroupOperation(
            service: service,
            options: .init(appId: nil, bundleId: nil, betaGroupName: groupName)
        )
        .execute()
        .id

        let testerIds = try await emails.asyncMap {
            try await GetBetaTesterOperation(
                service: service,
                options: .init(identifier: .email($0))
            )
            .execute()
            .id
        }

        try await RemoveTesterOperation(
            service: service,
            options: .init(
                removeStrategy: .removeTestersFromGroup(testerIds: testerIds, groupId: groupId)
            )
        )
        .execute()
    }
}
