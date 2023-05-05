// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import ArgumentParser
import Combine
import Foundation

struct DeleteBetaTesterCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "delete",
        abstract: "Delete beta testers"
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "Beta testers' emails")
    var emails: [String]

    func validate() throws {
        if emails.isEmpty {
            throw ValidationError("Missing expected argument '<emails>'")
        }
    }

    func run() throws {
        let service = try makeService()

        _ = try service.deleteBetaTesters(emails: emails)
    }
}
