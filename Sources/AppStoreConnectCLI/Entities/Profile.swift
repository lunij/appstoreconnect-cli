// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Foundation
import SwiftyTextTable

public struct Profile: Codable, Equatable {
    public let id: String?
    public let name: String?
    public let platform: String?
    public let profileContent: String?
    public let uuid: String?
    public let createdDate: Date?
    public let profileState: String?
    public let profileType: String?
    public let expirationDate: Date?

    public init(
        id: String?,
        name: String?,
        platform: String?,
        profileContent: String?,
        uuid: String?,
        createdDate: Date?,
        profileState: String?,
        profileType: String?,
        expirationDate: Date?
    ) {
        self.id = id
        self.name = name
        self.platform = platform
        self.profileContent = profileContent
        self.uuid = uuid
        self.createdDate = createdDate
        self.profileState = profileState
        self.profileType = profileType
        self.expirationDate = expirationDate
    }
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
