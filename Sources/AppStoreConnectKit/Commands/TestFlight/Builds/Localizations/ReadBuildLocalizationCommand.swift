// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Model

struct ReadBuildLocalizationCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "read",
        abstract: "Get a specific beta build localization resource."
    )

    @OptionGroup()
    var common: CommonOptions

    @OptionGroup()
    var build: BuildArguments

    @Argument(help: "The locale information of the build localization resource. eg. (en-AU)")
    var locale: String

    func run() async throws {
        let service = try makeService()

        let buildId = try await service.buildIdFrom(
            bundleId: build.bundleId,
            buildNumber: build.buildNumber,
            preReleaseVersion: build.preReleaseVersion
        )

        let buildLocalization = try await ReadBuildLocalizationOperation(
            service: service,
            options: .init(id: buildId, locale: locale)
        )
        .execute()

        [Model.BuildLocalization(buildLocalization)]
            .render(options: common.outputOptions)
    }
}
