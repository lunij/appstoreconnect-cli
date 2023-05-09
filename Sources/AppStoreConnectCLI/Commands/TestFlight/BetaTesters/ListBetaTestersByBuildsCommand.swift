// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models
import Bagbutik_TestFlight

struct ListBetaTestersByBuildsCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "listbybuilds",
        abstract: "List beta testers who were specifically assigned to one or more builds"
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The bundle ID of an application. (eg. com.example.app)")
    var bundleId: String

    @Option(
        parsing: .upToNextOption,
        help: "The pre-release version number of this build. (eg. 1.0.0)"
    )
    var preReleaseVersions: [String]

    @Option(
        parsing: .upToNextOption,
        help: "The version number of this build. (eg. 1)"
    )
    var versions: [String]

    private enum CommandError: Error, CustomStringConvertible {
        case noBuildsFound(preReleaseVersions: [String], versions: [String])

        var description: String {
            switch self {
            case let .noBuildsFound(preReleaseVersions, versions):
                return "No builds were found matching preReleaseVersions \(preReleaseVersions) and versions \(versions)"
            }
        }
    }

    func run() async throws {
        let service = try makeService()
        let appIds = try await service.appResourceIdsForBundleIds([bundleId])

        var filters: [ListBuildsV1.Filter] = [.app(appIds)]
        if versions.isNotEmpty {
            filters.append(.version(versions))
        }

        if preReleaseVersions.isNotEmpty {
            filters.append(.preReleaseVersion_version(preReleaseVersions))
        }

        let builds = try await service
            .request(.listBuildsV1(filters: filters))
            .data

        guard builds.isNotEmpty else {
            throw CommandError.noBuildsFound(preReleaseVersions: preReleaseVersions, versions: versions)
        }

        try await service.request(.listBetaTestersV1(
            filters: [.builds(builds.map(\.id))],
            includes: [.apps, .betaGroups]
        ))
        .data
        .map(BetaTester.init)
        .render(options: common.outputOptions)
    }
}
