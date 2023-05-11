// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import ArgumentParser
import Foundation

struct ListUserVisibleAppsCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "list-apps",
        abstract: "Get a list of apps that a user on your team can view."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The username of the user to list the apps for.")
    var username: String

    @Option(help: "Limit the number of apps to return (maximum 200).")
    var limit: Int?

    public func run() throws {
        #warning("not implemented")
        print(username as Any)
    }
}
