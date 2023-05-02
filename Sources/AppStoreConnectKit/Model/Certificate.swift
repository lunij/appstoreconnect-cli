// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import Model
import SwiftyTextTable

extension Model.Certificate {
    init(_ certificate: Bagbutik.Certificate) {
        let attributes = certificate.attributes
        self.init(
            id: certificate.id,
            name: attributes?.name,
            type: attributes?.certificateType?.rawValue,
            content: attributes?.certificateContent,
            platform: attributes?.platform?.rawValue,
            expirationDate: attributes?.expirationDate,
            serialNumber: attributes?.serialNumber
        )
    }

    init(_ certificate: LossyCertificate) {
        let attributes = certificate.attributes
        self.init(
            id: certificate.id,
            name: attributes?.name,
            type: attributes?.certificateType?.rawValue,
            content: attributes?.certificateContent,
            platform: attributes?.platform?.rawValue,
            expirationDate: attributes?.expirationDate,
            serialNumber: attributes?.serialNumber
        )
    }
}

extension Model.Certificate: ResultRenderable, TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "SerialNumber"),
            TextTableColumn(header: "Name"),
            TextTableColumn(header: "Type"),
            TextTableColumn(header: "Platform"),
            TextTableColumn(header: "Expiration Date"),
        ]
    }

    var tableRow: [CustomStringConvertible] {
        [
            self.serialNumber ?? "",
            self.name ?? "",
            self.type ?? "",
            self.platform ?? "",
            self.expirationDate ?? "",
        ]
    }
}
