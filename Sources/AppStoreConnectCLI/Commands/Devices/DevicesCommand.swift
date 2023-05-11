// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Foundation

struct DevicesCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "devices",
        abstract: "Register devices for development and testing.",
        subcommands: [
            ListDevicesCommand.self,
            ModifyDeviceCommand.self,
            ReadDeviceInfoCommand.self,
            RegisterDeviceCommand.self
            // SyncDevicesCommand.self, // Synchronise devices with configuration file
        ],
        defaultSubcommand: ListDevicesCommand.self
    )
}
