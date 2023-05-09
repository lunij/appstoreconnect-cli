// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

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

    func run() async throws {
        let service = try makeService()

        let testflightProgram = try await service.getTestFlightProgram(bundleIds: filterBundleIds)

        try writeTestFlightConfiguration(program: testflightProgram, to: outputPath)
    }
}
