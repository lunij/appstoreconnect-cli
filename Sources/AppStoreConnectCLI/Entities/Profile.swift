// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Foundation
import SwiftyTextTable

struct Profile: Codable, Equatable {
    let id: String?
    let name: String?
    let platform: String?
    let profileContent: String?
    let uuid: String?
    let createdDate: Date?
    let profileState: String?
    let profileType: String?
    let expirationDate: Date?
}

// MARK: - Extensions

extension Profile {
    init(_ apiProfile: AppStoreConnect_Swift_SDK.Profile) {
        let attributes = apiProfile.attributes

        self.init(
            id: apiProfile.id,
            name: attributes?.name,
            platform: attributes?.platform?.rawValue,
            profileContent: attributes?.profileContent,
            uuid: attributes?.uuid,
            createdDate: attributes?.createdDate,
            profileState: attributes?.profileState?.rawValue,
            profileType: attributes?.profileType?.rawValue,
            expirationDate: attributes?.expirationDate
        )
    }

    init(_ response: AppStoreConnect_Swift_SDK.ProfileResponse) {
        self.init(response.data)
    }
}

extension Profile: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "ID"),
            TextTableColumn(header: "UUID"),
            TextTableColumn(header: "Name"),
            TextTableColumn(header: "Platform"),
            TextTableColumn(header: "State"),
            TextTableColumn(header: "Type"),
            TextTableColumn(header: "Created Date"),
            TextTableColumn(header: "Expiration Date")
        ]
    }

    var tableRow: [CustomStringConvertible] {
        [
            id ?? "",
            uuid ?? "",
            name ?? "",
            platform ?? "",
            profileState ?? "",
            profileType ?? "",
            createdDate?.formattedDate ?? "",
            expirationDate?.formattedDate ?? ""
        ]
    }
}
