// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import Model
import SwiftyTextTable

// MARK: - API conveniences

extension Model.BundleId {
    init(_ bundleId: Bagbutik.BundleId) {
        let attributes = bundleId.attributes
        self.init(
            id: bundleId.id,
            identifier: attributes?.identifier,
            name: attributes?.name,
            platform: attributes?.platform?.rawValue,
            seedId: attributes?.seedId
        )
    }
}

// MARK: - TextTable conveniences

extension Model.BundleId: ResultRenderable, TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        return [
            TextTableColumn(header: "Identifier"),
            TextTableColumn(header: "Name"),
            TextTableColumn(header: "Platform"),
            TextTableColumn(header: "Seed ID"),
        ]
    }

    var tableRow: [CustomStringConvertible] {
        return [
            identifier ?? "",
            name ?? "",
            platform ?? "",
            seedId ?? "",
        ]
    }
}
