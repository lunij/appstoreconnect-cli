// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import SwiftyTextTable

struct BundleId: Codable, Equatable {
    let id: String
    let identifier: String?
    let name: String?
    let platform: String?
    let seedId: String?
}

// MARK: - Extensions

extension BundleId {
    init(_ bundleId: Bagbutik_Models.BundleId) {
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

extension BundleId: ResultRenderable {}

extension BundleId: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "Identifier"),
            TextTableColumn(header: "Name"),
            TextTableColumn(header: "Platform"),
            TextTableColumn(header: "Seed ID")
        ]
    }

    var tableRow: [CustomStringConvertible] {
        [
            identifier ?? "",
            name ?? "",
            platform ?? "",
            seedId ?? ""
        ]
    }
}
