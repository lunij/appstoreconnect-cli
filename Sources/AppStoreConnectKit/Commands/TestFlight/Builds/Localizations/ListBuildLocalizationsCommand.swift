// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Model

struct ListBuildLocalizationsCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "list",
        abstract: "Find and list beta build localization resources."
    )

    @OptionGroup()
    var common: CommonOptions

    @OptionGroup()
    var build: BuildArguments

    @Option(help: "Limit the number of resources to return.")
    var limit: Int?

    func run() async throws {
        let service = try makeService()

        let buildId = try await service.buildIdFrom(
            bundleId: build.bundleId,
            buildNumber: build.buildNumber,
            preReleaseVersion: build.preReleaseVersion
        )

        return try await ListBuildLocalizationOperation(
            service: service,
            options: .init(id: buildId, limit: limit)
        )
        .execute()
        .map(Model.BuildLocalization.init)
        .render(options: common.outputOptions)
    }
}
