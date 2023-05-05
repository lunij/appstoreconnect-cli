// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine
import Foundation
import Model
import SwiftyTextTable

// MARK: - API conveniences

extension Model.BundleId {
    init(_ attributes: AppStoreConnect_Swift_SDK.BundleId.Attributes) {
        self.init(
            identifier: attributes.identifier,
            name: attributes.name,
            platform: attributes.platform?.rawValue,
            seedId: attributes.seedId
        )
    }

    init(_ apiBundleId: AppStoreConnect_Swift_SDK.BundleId) {
        self.init(apiBundleId.attributes!)
    }

    init(_ response: AppStoreConnect_Swift_SDK.BundleIdResponse) {
        self.init(response.data)
    }
}

// MARK: - TextTable conveniences

extension Model.BundleId: ResultRenderable, TableInfoProvider {
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
