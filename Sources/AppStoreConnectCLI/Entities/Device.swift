// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Foundation
import SwiftyTextTable

public struct Device: Codable, Equatable {
    public let udid: String?
    public let addedDate: Date?
    public let name: String?
    public let deviceClass: String?
    public let model: String?
    public let platform: String?
    public let status: String?

    public init(
        udid: String?,
        addedDate: Date?,
        name: String?,
        deviceClass: String?,
        model: String?,
        platform: String?,
        status: String?
    ) {
        self.udid = udid
        self.addedDate = addedDate
        self.name = name
        self.deviceClass = deviceClass
        self.model = model
        self.platform = platform
        self.status = status
    }
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
