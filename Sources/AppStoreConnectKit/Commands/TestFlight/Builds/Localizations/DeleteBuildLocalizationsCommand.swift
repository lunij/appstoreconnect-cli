// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct DeleteBuildLocalizationsCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "delete",
        abstract: "Delete a specific beta build localization associated with a build."
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

        let buildLocalizationId = try await ReadBuildLocalizationOperation(
            service: service,
            options: .init(id: buildId, locale: locale)
        )
        .execute()
        .id

        try await DeleteBuildLocalizationOperation(
            service: service,
            options: .init(localizationId: buildLocalizationId)
        )
        .execute()
    }
}
