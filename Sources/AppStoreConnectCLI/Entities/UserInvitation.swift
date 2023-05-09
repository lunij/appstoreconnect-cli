// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Foundation
import SwiftyTextTable

struct UserInvitation: Codable, Equatable {
    let username: String?
    let firstName: String?
    let lastName: String?
    let roles: [String]
    let provisioningAllowed: Bool
    let allAppsVisible: Bool
    let expirationDate: Date?
}

// MARK: - Extensions

extension UserInvitation {
    init(_ apiInvitation: Bagbutik_Models.UserInvitation) {
        let attributes = apiInvitation.attributes
        self.init(
            username: attributes?.email,
            firstName: attributes?.firstName,
            lastName: attributes?.lastName,
            roles: attributes?.roles?.map(\.rawValue) ?? [],
            provisioningAllowed: attributes?.provisioningAllowed ?? false,
            allAppsVisible: attributes?.allAppsVisible ?? false,
            expirationDate: attributes?.expirationDate
        )
    }
}

extension UserInvitation: ResultRenderable {}

extension UserInvitation: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "Email"),
            TextTableColumn(header: "First Name"),
            TextTableColumn(header: "Last Name"),
            TextTableColumn(header: "Roles"),
            TextTableColumn(header: "Expiration Date"),
            TextTableColumn(header: "Provisioning Allowed"),
            TextTableColumn(header: "All Apps Visible")
        ]
    }

    var tableRow: [CustomStringConvertible] {
        [
            username ?? "",
            firstName ?? "",
            lastName ?? "",
            roles.joined(separator: ", "),
            expirationDate ?? "",
            provisioningAllowed.yesNo,
            allAppsVisible.yesNo
        ]
    }
}
