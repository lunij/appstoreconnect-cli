// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import Model
import SwiftyTextTable

extension Model.PreReleaseVersion {
    init(
        _ preReleaseVersion: Bagbutik.PrereleaseVersion,
        _ includes: [Bagbutik.PreReleaseVersionsResponse.Included]
    ) {
        var app: Bagbutik.App?

        for include in includes {
            if case let .app(value) = include {
                app = value
            }
        }

        self.init(
            app: app.map(Model.App.init),
            platform: preReleaseVersion.attributes?.platform?.rawValue,
            version: preReleaseVersion.attributes?.version
        )
    }
}

extension Model.PreReleaseVersion: ResultRenderable, TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        return [
            TextTableColumn(header: "App ID"),
            TextTableColumn(header: "App Bundle ID"),
            TextTableColumn(header: "App Name"),
            TextTableColumn(header: "Platform"),
            TextTableColumn(header: "Version"),
        ]
    }

    var tableRow: [CustomStringConvertible] {
        return [
            app?.id,
            app?.bundleId,
            app?.name,
            platform,
            version,
        ].map { $0 ?? "" }
    }
}
