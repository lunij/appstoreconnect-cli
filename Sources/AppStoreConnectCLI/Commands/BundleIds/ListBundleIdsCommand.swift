// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct ListBundleIdsCommand: CommonParsableCommand {
    public static var configuration = CommandConfiguration(
        commandName: "list",
        abstract: "Find and list bundle IDs that are registered to your team."
    )

    @OptionGroup()
    var common: CommonOptions

    @Option(
        help: "Limit the number of resources (maximum 200).",
        transform: { Int($0).map { min($0, 200) } }
    )
    var limit: Int?

    @Option(parsing: .upToNextOption, help: "Filter the results by reverse-DNS bundle ID identifier (eg. com.example.app)")
    var filterIdentifier: [String] = []

    @Option(parsing: .upToNextOption, help: "Filter the results by app name")
    var filterName: [String] = []

    @Option(
        parsing: .upToNextOption,
        help: "Filter the results by platform: \(BundleIdPlatform.allValueStringsFormatted)",
        completion: .list(BundleIdPlatform.allValueStrings)
    )
    var filterPlatform: [BundleIdPlatform] = []

    @Option(parsing: .upToNextOption, help: "Filter the results by seed ID")
    var filterSeedId: [String] = []

    func run() async throws {
        let service = try makeService()
        try await ListBundleIdsOperation(
            service: service,
            options: .init(
                identifiers: filterIdentifier,
                names: filterName,
                platforms: filterPlatform,
                seedIds: filterSeedId,
                limit: limit
            )
        )
        .execute()
        .map { BundleId($0) }
        .render(options: common.outputOptions)
    }
}
