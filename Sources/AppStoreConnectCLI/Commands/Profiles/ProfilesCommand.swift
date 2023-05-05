// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Foundation

struct ProfilesCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "profiles",
        abstract: "Create, delete, and download provisioning profiles that enable app installations for development and distribution.",
        subcommands: [
            CreateProfileCommand.self,
            DeleteProfileCommand.self,
            ListProfilesCommand.self,
            ListProfilesByBundleIdCommand.self,
            ReadProfileCommand.self
        ],
        defaultSubcommand: ListProfilesCommand.self
    )
}
