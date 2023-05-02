// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import struct Model.App
import SwiftyTextTable

extension App: ResultRenderable {}

// MARK: - API conveniences

extension App {
    init(_ apiApp: Bagbutik.App) {
        let attributes = apiApp.attributes
        self.init(
            id: apiApp.id,
            bundleId: attributes?.bundleId,
            name: attributes?.name,
            primaryLocale: attributes?.primaryLocale,
            sku: attributes?.sku
        )
    }
}

// MARK: - TextTable conveniences

extension App: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        return [
            TextTableColumn(header: "App ID"),
            TextTableColumn(header: "App Bundle ID"),
            TextTableColumn(header: "Name"),
            TextTableColumn(header: "Primary Locale"),
            TextTableColumn(header: "SKU"),
        ]
    }

    var tableRow: [CustomStringConvertible] {
        return [
            id,
            bundleId ?? "",
            name ?? "",
            primaryLocale ?? "",
            sku ?? "",
        ]
    }
}
