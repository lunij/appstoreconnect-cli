// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Foundation
import SwiftyTextTable

struct Device: Codable, Equatable {
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
    init(_ attributes: AppStoreConnect_Swift_SDK.Device.Attributes) {
        self.init(
            udid: attributes.udid,
            addedDate: attributes.addedDate,
            name: attributes.name,
            deviceClass: attributes.deviceClass?.rawValue,
            model: attributes.model,
            platform: attributes.platform?.rawValue,
            status: attributes.status?.rawValue
        )
    }

    init(_ apiDevice: AppStoreConnect_Swift_SDK.Device) {
        self.init(apiDevice.attributes)
    }

    init(_ response: AppStoreConnect_Swift_SDK.DeviceResponse) {
        self.init(response.data)
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
