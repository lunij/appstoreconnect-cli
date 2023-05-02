// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct ProfilesCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "profiles",
        abstract: "Create, delete, update, list and download provisioning profiles that enable app installations for development and distribution.",
        subcommands: [
            CreateProfileCommand.self,
            DeleteProfileCommand.self,
            ListProfilesCommand.self,
            ListProfilesByBundleIdCommand.self,
            ReadProfileCommand.self,
            UpdateProfileCommand.self
        ],
        defaultSubcommand: ListProfilesCommand.self
    )
}
