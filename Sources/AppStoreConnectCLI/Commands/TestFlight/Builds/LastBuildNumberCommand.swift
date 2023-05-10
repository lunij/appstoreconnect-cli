// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct LastBuildNumberCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "last",
        abstract: "Find the last build of an app in App Store Connect"
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The app's bundle identifier, eg. com.example.App")
    var bundleId: String

    @Argument(help: "The app's version, eg. 1.2")
    var version: String?

    func run() async throws {
        let service = try makeService()

        let apps = try await service.request(.listAppsV1(filters: [.bundleId([bundleId])])).data

        if apps.count > 1 {
            throw Error.multipleAppsFound
        }

        guard let app = apps.first else {
            throw Error.appNotFound
        }

        let versions = try await service
            .requestAllPages(.listPreReleaseVersionsV1(
                filters: [.app([app.id])],
                sorts: [.versionAscending]
            ))
            .data

        guard var preReleaseVersion = versions.last else {
            throw Error.noVersionsAvailable
        }

        if let version {
            guard let versionFound = versions.first(where: { $0.attributes?.version == version }) else {
                throw Error.versionNotFound
            }
            preReleaseVersion = versionFound
        }

        print(preReleaseVersion.attributes?.version ?? "?")

        let builds = try await service.requestAllPages(.listBuildsV1(filters: [.preReleaseVersion([preReleaseVersion.id])])).data

        guard let lastBuildNumber = builds.compactMap(\.attributes?.version).compactMap(Int.init).max() else {
            throw Error.lastBuildNumberNotFound
        }

        print(lastBuildNumber)
    }

    enum Error: Swift.Error, CustomStringConvertible, Equatable {
        case appNotFound
        case lastBuildNumberNotFound
        case multipleAppsFound
        case noVersionsAvailable
        case versionNotFound

        var description: String {
            switch self {
            case .appNotFound:
                return "App not found"
            case .lastBuildNumberNotFound:
                return "Last build number not found"
            case .multipleAppsFound:
                return "Multiple apps found"
            case .noVersionsAvailable:
                return "No versions available"
            case .versionNotFound:
                return "Version not found"
            }
        }
    }
}
