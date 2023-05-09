// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine
import Foundation
import SwiftyTextTable

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
            attributes?.email ?? "",
            attributes?.firstName ?? "",
            attributes?.lastName ?? "",
            attributes?.roles?.map(\.rawValue).joined(separator: ", ") ?? "",
            attributes?.expirationDate ?? "",
            attributes?.provisioningAllowed?.yesNo ?? "",
            attributes?.allAppsVisible?.yesNo ?? ""
        ]
    }
}

extension APIEndpoint where T == UserInvitationResponse {
    static func invite(user: User) -> Self {
        invite(
            userWithEmail: user.username,
            firstName: user.firstName,
            lastName: user.lastName,
            roles: user.roles.compactMap(UserRole.init(rawValue:)),
            allAppsVisible: user.allAppsVisible,
            provisioningAllowed: user.provisioningAllowed,
            appsVisibleIds: user.allAppsVisible ? [] : user.visibleApps
        )
    }
}

extension AppStoreConnectService {
    /// Find the opaque internal identifier for this invitation; search by email address.
    ///
    /// This is an App Store Connect internal identifier
    func invitationIdentifier(matching email: String) throws -> AnyPublisher<String, Error> {
        let endpoint = APIEndpoint.invitedUsers(
            filter: [.email([email])]
        )

        return request(endpoint)
            .map { $0.data.filter { $0.attributes?.email == email } }
            .compactMap { response -> String? in
                if response.count == 1 {
                    return response.first?.id
                }
                fatalError("User with email address '\(email)' not unique or not found")
            }
            .eraseToAnyPublisher()
    }
}
