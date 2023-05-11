// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import FileSystem
import Foundation
import Model

struct TestFlightPullCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "pull",
        abstract: "Pull TestFlight configuration, overwriting local configuration files."
    )

    @OptionGroup()
    var common: CommonOptions

    @Option(
        parsing: .upToNextOption,
        help: "Filter by only including apps with the specified bundleIds in the configuration"
    )
    var filterBundleIds: [String] = []

    @Option(help: "Path to output/write the TestFlight configuration.")
    var outputPath = "./config/apps"

    func run() throws {
        let service = try makeService()

        let testflightProgram = try service.getTestFlightProgram(bundleIds: filterBundleIds)

        try FileSystem.writeTestFlightConfiguration(program: testflightProgram, to: outputPath)
    }
}
