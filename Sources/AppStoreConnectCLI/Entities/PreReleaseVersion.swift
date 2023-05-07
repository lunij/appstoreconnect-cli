// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Foundation
import SwiftyTextTable

public struct PreReleaseVersion: Codable, Equatable {
    public let app: App?
    public let platform: String?
    public let version: String?

    public init(
        app: App?,
        platform: String?,
        version: String?
    ) {
        self.app = app
        self.platform = platform
        self.version = version
    }
}

// MARK: - Extensions

extension PreReleaseVersion {
    init(
        _ preReleaseVersion: AppStoreConnect_Swift_SDK.PrereleaseVersion,
        _ includes: [AppStoreConnect_Swift_SDK.PreReleaseVersionRelationship]?
    ) {
        let relationships = preReleaseVersion.relationships

        let includedApps = includes?.compactMap { relationship -> AppStoreConnect_Swift_SDK.App? in
            if case let .app(app) = relationship {
                return app
            }
            return nil
        }

        let appDetails = includedApps?.first(where: { relationships?.app?.data?.id == $0.id })
        let app = appDetails.map(App.init)

        self.init(
            app: app,
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
