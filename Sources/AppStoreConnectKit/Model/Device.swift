// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import Model
import SwiftyTextTable

// MARK: - API conveniences

extension Model.Device {
    init(_ device: Bagbutik.Device) {
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

// MARK: - TextTable conveniences

extension Model.Device: ResultRenderable, TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        return [
            TextTableColumn(header: "UDID"),
            TextTableColumn(header: "Name"),
            TextTableColumn(header: "Date Added"),
            TextTableColumn(header: "Device Class"),
            TextTableColumn(header: "Model"),
            TextTableColumn(header: "Platform"),
            TextTableColumn(header: "Status"),
        ]
    }

    var tableRow: [CustomStringConvertible] {
        return [
          udid,
          name,
          addedDate?.formattedDate,
          deviceClass,
          model,
          platform,
          status,
        ].map { $0 ?? "" }
    }
}
