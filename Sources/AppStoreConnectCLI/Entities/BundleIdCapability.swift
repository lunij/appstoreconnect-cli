// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Foundation
import SwiftyTextTable

struct BundleIdCapability: Codable, Equatable {
    let capabilityType: String?

    #warning("support Capability Settings")
}

// MARK: - Extensions

extension BundleIdCapability {
    init(_ attributes: Bagbutik_Models.BundleIdCapability.Attributes?) {
        self.init(capabilityType: attributes?.capabilityType?.rawValue)
    }

    init(_ apiBundleId: Bagbutik_Models.BundleIdCapability) {
        self.init(apiBundleId.attributes)
    }
}

extension BundleIdCapability: ResultRenderable {}

extension BundleIdCapability: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "Capability Type")
        ]
    }

    var tableRow: [CustomStringConvertible] {
        [
            capabilityType ?? ""
        ]
    }
}
