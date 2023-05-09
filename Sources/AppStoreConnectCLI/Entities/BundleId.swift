// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine
import Foundation
import SwiftyTextTable

struct BundleId: Codable, Equatable {
    let identifier: String?
    let name: String?
    let platform: String?
    let seedId: String?
}

// MARK: - Extensions

extension BundleId {
    init(_ apiBundleId: AppStoreConnect_Swift_SDK.BundleId) {
        let attributes = apiBundleId.attributes
        self.init(
            identifier: attributes?.identifier,
            name: attributes?.name,
            platform: attributes?.platform?.rawValue,
            seedId: attributes?.seedId
        )
    }

    init(_ response: AppStoreConnect_Swift_SDK.BundleIdResponse) {
        self.init(response.data)
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
