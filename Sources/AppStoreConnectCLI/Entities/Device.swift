// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Foundation
import SwiftyTextTable

struct Device: Codable, Equatable {
    let id: String
    let udid: String?
    let addedDate: Date?
    let name: String?
    let deviceClass: String?
    let model: String?
    let platform: String?
    let status: String?
}

// MARK: - Extensions

extension Device {
    init(_ device: Bagbutik_Models.Device) {
        let attributes = device.attributes
        self.init(
            id: device.id,
            udid: attributes?.udid,
            addedDate: attributes?.addedDate,
            name: attributes?.name,
            deviceClass: attributes?.deviceClass?.rawValue,
            model: attributes?.model,
            platform: attributes?.platform?.rawValue,
            status: attributes?.status?.rawValue
        )
    }
}

extension Device: ResultRenderable {}

extension Device: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "UDID"),
            TextTableColumn(header: "Name"),
            TextTableColumn(header: "Date Added"),
            TextTableColumn(header: "Device Class"),
            TextTableColumn(header: "Model"),
            TextTableColumn(header: "Platform"),
            TextTableColumn(header: "Status")
        ]
    }

    var tableRow: [CustomStringConvertible] {
        [
            udid,
            name,
            addedDate?.formattedDate,
            deviceClass,
            model,
            platform,
            status
        ].map { $0 ?? "" }
    }
}
