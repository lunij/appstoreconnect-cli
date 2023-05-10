// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Foundation

public struct TestFlightBuildsCommand: ParsableCommand {
    public static var configuration = CommandConfiguration(
        commandName: "builds",
        abstract: "Information about app builds.",
        subcommands: [
            LastBuildNumberCommand.self,
            LocalizationsCommand.self,
            ListBuildsCommand.self,
            ReadBuildCommand.self,
            ExpireBuildCommand.self,
            RemoveBuildFromGroupsCommand.self,
            AddGroupsToBuildCommand.self
        ],
        defaultSubcommand: ListBuildsCommand.self
    )

    public init() {}
}
