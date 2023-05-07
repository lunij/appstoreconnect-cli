// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine
import Foundation
import SwiftyTextTable

public struct BundleId: Codable, Equatable {
    public let identifier: String?
    public let name: String?
    public let platform: String?
    public let seedId: String?

    public init(
        identifier: String?,
        name: String?,
        platform: String?,
        seedId: String?
    ) {
        self.identifier = identifier
        self.name = name
        self.platform = platform
        self.seedId = seedId
    }
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
