// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct CreateBuildLocalizationsCommand: CommonParsableCommand, CreateUpdateBuildLocalizationCommand {
    static var configuration = CommandConfiguration(
        commandName: "create",
        abstract: "Create localized What’s New text for a build.",
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

        let buildLocalization = try await CreateBuildLocalizationOperation(
            service: service,
            options: .init(
                buildId: buildId,
                locale: localization.locale,
                whatsNew: readWhatsNew()
            )
        )
        .execute()

        try [BuildLocalization(buildLocalization)]
            .render(options: common.outputOptions)
    }
}
