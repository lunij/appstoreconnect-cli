// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct RemoveTesterFromGroupsCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "removegroup",
        abstract: "Remove a beta tester from beta groups"
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "Beta tester's email address.")
    var email: String

    @Argument(help: "Names of TestFlight beta tester groups that the tester will be removed from.")
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

        let groupIds = try await groupNames.asyncFlatMap {
            try await ListBetaGroupsOperation(
                service: service,
                options: .init(appIds: [], names: [$0], sorts: [])
            )
            .execute()
            .map(\.betaGroup.id)
        }

        try await RemoveTesterOperation(
            service: service,
            options: .init(
                removeStrategy: .removeTesterFromGroups(testerId: testerId, groupIds: groupIds)
            )
        )
        .execute()
    }
}
