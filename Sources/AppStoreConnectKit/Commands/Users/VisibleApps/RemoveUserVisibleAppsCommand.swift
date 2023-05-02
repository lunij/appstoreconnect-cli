// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct RemoveUserVisibleAppsCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "remove-apps",
        abstract: "Remove a user on your team's access to one or more apps."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The username of the user to modify.")
    var username: String

    @Argument(help: "The list of bundle ids of apps to remove access to.")
    var bundleIds: [String]

    public func run() throws {
        print(bundleIds)
    }
}
