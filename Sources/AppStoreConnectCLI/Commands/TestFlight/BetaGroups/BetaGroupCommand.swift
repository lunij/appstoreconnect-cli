// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Foundation

struct BetaGroupCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "betagroup",
        abstract: """
        List, create, modify and delete groups of beta testers that have access to \
        one or more builds.
        """,
        subcommands: [
            AddTestersToGroupCommand.self,
            CreateBetaGroupCommand.self,
            DeleteBetaGroupCommand.self,
            ListBetaGroupsCommand.self,
            ModifyBetaGroupCommand.self,
            ReadBetaGroupCommand.self,
            RemoveTestersFromGroupCommand.self
        ],
        defaultSubcommand: ListBetaGroupsCommand.self
    )
}
