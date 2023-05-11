// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import SwiftyTextTable

struct PreReleaseVersion: Codable, Equatable {
    let app: App?
    let platform: String?
    let version: String?
}

// MARK: - Extensions

extension Bagbutik_Models.PreReleaseVersionsResponse {
    func preReleaseVersions() throws -> [PreReleaseVersion] {
        try data.map { version in
            try .init(version, app: getApp(for: version))
        }
    }
}

private extension PreReleaseVersion {
    init(
        _ preReleaseVersion: Bagbutik_Models.PrereleaseVersion,
        app: Bagbutik_Models.App?
    ) throws {
        self.init(
            app: try app.map(App.init),
            platform: preReleaseVersion.attributes?.platform?.rawValue,
            version: preReleaseVersion.attributes?.version
        )
    }
}

extension PreReleaseVersion: ResultRenderable {}

extension PreReleaseVersion: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "App ID"),
            TextTableColumn(header: "App Bundle ID"),
            TextTableColumn(header: "App Name"),
            TextTableColumn(header: "Platform"),
            TextTableColumn(header: "Version")
        ]
    }

    var tableRow: [CustomStringConvertible] {
        [
            app?.id,
            app?.bundleId,
            app?.name,
            platform,
            version
        ].map { $0 ?? "" }
    }
}
