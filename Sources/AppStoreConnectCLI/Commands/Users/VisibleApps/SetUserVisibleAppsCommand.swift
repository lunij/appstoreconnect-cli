// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct SetUserVisibleAppsCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "set-apps",
        abstract: "Set the list of apps a user on your team can see."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The username of the user to modify.")
    var username: String

    @Argument(help: "The list of bundle ids of apps to set for the user.")
    var bundleIds: [String]

    public func run() throws {
        #warning("not implemented")
        print(bundleIds)
    }
}
