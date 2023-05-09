// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct ExpireBuildCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "expire",
        abstract: "Expire a build."
    )

    @OptionGroup()
    var common: CommonOptions

    @OptionGroup()
    var build: BuildArguments

    func run() async throws {
        let service = try makeService()

        let appId = try await GetAppOperation(
            service: service,
            options: .init(bundleId: build.bundleId)
        )
        .execute()
        .id

        let buildId = try await ReadBuildOperation(
            service: service,
            options: .init(
                appId: appId,
                buildNumber: build.buildNumber,
                preReleaseVersion: build.preReleaseVersion
            )
        )
        .execute()
        .build
        .id

        try await ExpireBuildOperation(service: service, options: .init(buildId: buildId)).execute()
    }
}
