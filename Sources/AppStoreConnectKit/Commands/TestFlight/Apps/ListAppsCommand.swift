// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik
import struct Model.App

struct ListAppsCommand: CommonParsableCommand {

    static var configuration = CommandConfiguration(
        commandName: "list",
        abstract: "Find and list apps added in App Store Connect"
    )

    @OptionGroup()
    var common: CommonOptions

    @Option(help: "Limit the number of resources (maximum 200).")
    var limit: Int?

    @Option(parsing: .upToNextOption, help: "Filter the results by the specified bundle IDs")
    var filterBundleIds: [String] = []

    @Option(parsing: .upToNextOption, help: "Filter the results by the specified app names")
    var filterNames: [String] = []

    @Option(parsing: .upToNextOption, help: "Filter the results by the specified app SKUs")
    var filterSkus: [String] = []

    func run() async throws {
        let service = try makeService()

        let operation = ListAppsOperation(
            service: service,
            options: .init(bundleIds: filterBundleIds, names: filterNames, skus: filterSkus, limit: limit)
        )

        let apps = try await operation.execute().map { Model.App.init($0) }

        apps.render(options: common.outputOptions)
    }
}
