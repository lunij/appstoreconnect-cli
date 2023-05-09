// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Foundation
import SwiftyTextTable

struct Certificate: Codable, Equatable {
    let id: String
    let name: String?
    let type: String?
    let content: String?
    let platform: String?
    let expirationDate: Date?
    let serialNumber: String?
}

// MARK: - Extensions

extension Certificate {
    init(_ certificate: Bagbutik_Models.Certificate) {
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

extension Certificate: ResultRenderable {}

extension Certificate: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "SerialNumber"),
            TextTableColumn(header: "Name"),
            TextTableColumn(header: "Type"),
            TextTableColumn(header: "Platform"),
            TextTableColumn(header: "Expiration Date")
        ]
    }

    var tableRow: [CustomStringConvertible] {
        [
            serialNumber ?? "",
            name ?? "",
            type ?? "",
            platform ?? "",
            expirationDate ?? ""
        ]
    }
}
