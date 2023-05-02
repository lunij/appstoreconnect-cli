// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import FileSystem
import Model

struct UpdateBuildLocalizationsCommand: CommonParsableCommand, CreateUpdateBuildLocalizationCommand {
    static var configuration = CommandConfiguration(
        commandName: "update",
        abstract: "Update the localized What’s New text for a specific beta build and locale.",
        discussion: """
        Text from `stdin` will be read when a file path or what's new isn't specified.
        """
    )

    @OptionGroup()
    var common: CommonOptions

    @OptionGroup()
    var build: BuildArguments

    @OptionGroup()
    var localization: BuildLocalizationInputArguments

    func validate() throws {
        try validateWhatsNewInput()
    }

    func run() async throws {
        let service = try makeService()

        let buildId = try await service.buildIdFrom(
            bundleId: build.bundleId,
            buildNumber: build.buildNumber,
            preReleaseVersion: build.preReleaseVersion
        )

        let buildLocalizationId = try await ReadBuildLocalizationOperation(
            service: service,
            options: .init(id: buildId, locale: localization.locale)
        )
        .execute()
        .id

        let buildLocalization = try await UpdateBuildLocalizationOperation(
            service: service,
            options: .init(
                localizationId: buildLocalizationId,
                whatsNew: readWhatsNew()
            )
        )
        .execute()

        [Model.BuildLocalization(buildLocalization)]
            .render(options: common.outputOptions)
    }
}
