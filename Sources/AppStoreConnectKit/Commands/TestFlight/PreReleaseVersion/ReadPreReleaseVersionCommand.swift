// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik
import Model

struct ReadPreReleaseVersionCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "read",
        abstract: "Get information about a specific prerelease version."
    )

    @OptionGroup()
    var common: CommonOptions

    @OptionGroup()
    var appLookupArgument: AppLookupArgument

    @Argument(
        help: ArgumentHelp(
            "The version number of the prerelease version of your app.",
            discussion: "Please input a specific version no"
        )
    )
    var version: String

    func run() async throws {
        let service = try makeService()

        var filterAppId = ""

        switch appLookupArgument.identifier {
        case let .appId(appId):
            filterAppId = appId
        case let .bundleId(bundleId):
            filterAppId = try await GetAppOperation(
                service: service,
                options: .init(bundleId: bundleId)
            )
            .execute()
            .id
        }

        let output = try await ReadPreReleaseVersionOperation(
            service: service,
            options: .init(filterAppId: filterAppId, filterVersion: version)
        )
        .execute()

        Model
            .PreReleaseVersion(output.preReleaseVersion, output.includes)
            .render(options: common.outputOptions)
    }
}
