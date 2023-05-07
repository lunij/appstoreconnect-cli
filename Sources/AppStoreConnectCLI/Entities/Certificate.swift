// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Foundation
import SwiftyTextTable

public struct Certificate: Codable, Equatable {
    public let name: String?
    public let type: String?
    public let content: String?
    public let platform: String?
    public let expirationDate: Date?
    public let serialNumber: String?

    public init(
        name: String?,
        type: String?,
        content: String?,
        platform: String?,
        expirationDate: Date?,
        serialNumber: String?
    ) {
        self.name = name
        self.type = type
        self.content = content
        self.platform = platform
        self.expirationDate = expirationDate
        self.serialNumber = serialNumber
    }
}

// MARK: - Extensions

extension Certificate {
    init(_ certificate: AppStoreConnect_Swift_SDK.Certificate) {
        self.init(certificate.attributes)
    }

    init(_ attributes: AppStoreConnect_Swift_SDK.Certificate.Attributes) {
        self.init(
            name: attributes.name,
            type: attributes.certificateType?.rawValue,
            content: attributes.certificateContent,
            platform: attributes.platform?.rawValue,
            expirationDate: attributes.expirationDate,
            serialNumber: attributes.serialNumber
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
