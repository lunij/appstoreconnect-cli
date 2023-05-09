// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import SwiftyTextTable

struct App: Codable, Equatable {
    let id: String
    var bundleId: String
    var name: String?
    var primaryLocale: String?
    var sku: String?

    enum Error: Swift.Error, CustomStringConvertible, Equatable {
        case bundleIdMissing(id: String)

        var description: String {
            switch self {
            case let .bundleIdMissing(id):
                return "The app with the id '\(id)' is missing the bundle identifier"
            }
        }
    }
}

// MARK: - Extensions

extension App {
    init(_ app: Bagbutik_Models.App) throws {
        let attributes = app.attributes

        guard let bundleId = attributes?.bundleId else {
            throw Error.bundleIdMissing(id: app.id)
        }

        self.init(
            id: app.id,
            bundleId: bundleId,
            name: attributes?.name,
            primaryLocale: attributes?.primaryLocale,
            sku: attributes?.sku
        )
    }
}

extension App: ResultRenderable {}

extension App: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "App ID"),
            TextTableColumn(header: "App Bundle ID"),
            TextTableColumn(header: "Name"),
            TextTableColumn(header: "Primary Locale"),
            TextTableColumn(header: "SKU")
        ]
    }

    var tableRow: [CustomStringConvertible] {
        [
            id,
            bundleId,
            name ?? "",
            primaryLocale ?? "",
            sku ?? ""
        ]
    }
}
