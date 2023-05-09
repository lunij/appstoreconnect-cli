// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import SwiftyTextTable

struct PreReleaseVersion: Codable, Equatable {
    let app: App?
    let platform: String?
    let version: String?
}

// MARK: - Extensions

extension PreReleaseVersion {
    init(
        _ preReleaseVersion: Bagbutik_Models.PrereleaseVersion,
        _ includes: [Bagbutik_Models.PreReleaseVersionsResponse.Included]
    ) throws {
        var app: Bagbutik_Models.App?

        for include in includes {
            if case let .app(value) = include {
                app = value
            }
        }

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
