// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

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

    func run() throws {
        let service = try makeService()

        try service.removeTesterFromGroups(email: email, groupNames: groupNames)
    }
}
