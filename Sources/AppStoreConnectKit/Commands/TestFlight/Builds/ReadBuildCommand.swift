// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik
import Model

struct ReadBuildCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "read",
        abstract: "Get information about a specific build."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "An opaque resource ID that uniquely identifies the build")
    var bundleId: String

    @Argument(help: "The build number of this build")
    var buildNumber: String

    @Argument(help: "The pre-release version number of this build")
    var preReleaseVersion: String

    func run() async throws {
        let service = try makeService()
        let appId = try await GetAppOperation(
            service: service,
            options: .init(bundleId: bundleId)
        )
        .execute()
        .id

        let output = try await ReadBuildOperation(
            service: service,
            options: .init(appId: appId, buildNumber: buildNumber, preReleaseVersion: preReleaseVersion)
        )
        .execute()

        Model
            .Build(output.build, output.includes)
            .render(options: common.outputOptions)
    }
}
