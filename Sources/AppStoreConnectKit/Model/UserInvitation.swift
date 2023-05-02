// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import struct Model.UserInvitation
import SwiftyTextTable

extension Model.UserInvitation {
    init(_ apiInvitation: Bagbutik.UserInvitation) {
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

extension Model.UserInvitation: ResultRenderable { }

extension Model.UserInvitation: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
       return [
            TextTableColumn(header: "Email"),
            TextTableColumn(header: "First Name"),
            TextTableColumn(header: "Last Name"),
            TextTableColumn(header: "Roles"),
            TextTableColumn(header: "Expiration Date"),
            TextTableColumn(header: "Provisioning Allowed"),
            TextTableColumn(header: "All Apps Visible"),
        ]
    }

    var tableRow: [CustomStringConvertible] {
        return [
            username ?? "",
            firstName ?? "",
            lastName ?? "",
            roles.joined(separator: ", "),
            expirationDate ?? "",
            provisioningAllowed.toYesNo(),
            allAppsVisible.toYesNo(),
        ]
    }
}
