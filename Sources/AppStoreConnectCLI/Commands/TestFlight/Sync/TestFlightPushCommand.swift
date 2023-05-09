// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct TestFlightPushCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "push",
        abstract: "Push local TestFlight configuration to the App Store Connect."
    )

    @OptionGroup()
    var common: CommonOptions

    @Option(help: "Path to read in the TestFlight configuration.")
    var inputPath = "./config/apps"

    func run() async throws {
        let service = try makeService()

        let local = try readTestFlightConfiguration(from: inputPath)
        let remote = try await service.getTestFlightProgram()

        let difference = TestFlightProgramDifference(local: local, remote: remote)

        difference.changes.forEach { print($0.description) }

        #warning("Push the testflight program to the API")

        throw CommandError.unimplemented
    }
}
