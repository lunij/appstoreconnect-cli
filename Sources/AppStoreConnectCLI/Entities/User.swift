// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine
import Foundation
import SwiftyTextTable

public struct User: Codable, Equatable {
    public let username: String
    public let firstName: String
    public let lastName: String
    public let roles: [String]
    public let provisioningAllowed: Bool
    public let allAppsVisible: Bool
    public let visibleApps: [String]?

    public init(
        username: String,
        firstName: String,
        lastName: String,
        roles: [String],
        provisioningAllowed: Bool,
        allAppsVisible: Bool,
        visibleApps: [String]?
    ) {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.roles = roles
        self.provisioningAllowed = provisioningAllowed
        self.allAppsVisible = allAppsVisible
        self.visibleApps = visibleApps
    }
}

// MARK: - Extensions

extension User {
    static func fromAPIUser(_ apiUser: AppStoreConnect_Swift_SDK.User) -> User? {
        guard let attributes = apiUser.attributes,
              let username = attributes.username
        else {
            #warning("error handling")
            return nil
        }

        let visibleApps = apiUser.relationships?.visibleApps?.data?.map(\.type)

        return User(
            username: username,
            firstName: attributes.firstName ?? "",
            lastName: attributes.lastName ?? "",
            roles: attributes.roles?.map(\.rawValue) ?? [],
            provisioningAllowed: attributes.provisioningAllowed ?? false,
            allAppsVisible: attributes.allAppsVisible ?? false,
            visibleApps: visibleApps
        )
    }

    static func fromAPIResponse(_ response: UsersResponse) -> [User] {
        let users: [AppStoreConnect_Swift_SDK.User] = response.data

        return users.compactMap { (user: AppStoreConnect_Swift_SDK.User) -> User in
            let userVisibleAppIds = user.relationships?.visibleApps?.data?.map(\.id)
            let userVisibleApps = response.included?.filter {
                userVisibleAppIds?.contains($0.id) ?? false
            }

            guard let attributes = user.attributes else { fatalError("Failed to init user") }

            return User(attributes: attributes, visibleApps: userVisibleApps)
        }
    }

    init(attributes: AppStoreConnect_Swift_SDK.User.Attributes, visibleApps: [AppStoreConnect_Swift_SDK.App]? = nil) {
        self.init(
            username: attributes.username ?? "",
            firstName: attributes.firstName ?? "",
            lastName: attributes.lastName ?? "",
            roles: attributes.roles?.map(\.rawValue) ?? [],
            provisioningAllowed: attributes.provisioningAllowed ?? false,
            allAppsVisible: attributes.provisioningAllowed ?? false,
            visibleApps: visibleApps?.compactMap { $0.attributes?.bundleId }
        )
    }
}

extension User: ResultRenderable {}

extension User: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "Username"),
            TextTableColumn(header: "First Name"),
            TextTableColumn(header: "Last Name"),
            TextTableColumn(header: "Role"),
            TextTableColumn(header: "Provisioning Allowed"),
            TextTableColumn(header: "All Apps Visible"),
            TextTableColumn(header: "Visible Apps")
        ]
    }

    var tableRow: [CustomStringConvertible] {
        [
            username,
            firstName,
            lastName,
            roles.joined(separator: ", "),
            provisioningAllowed.yesNo,
            allAppsVisible.yesNo,
            visibleApps?.joined(separator: ", ") ?? ""
        ]
    }
}

extension AppStoreConnectService {
    /// Find the opaque internal identifier for this user; search by email address.
    ///
    /// This is an App Store Connect internal identifier
    func userIdentifier(matching email: String) -> AnyPublisher<String, Error> {
        let endpoint = APIEndpoint.users(
            filter: [.username([email])]
        )

        return request(endpoint)
            .map { $0.data.filter { $0.attributes?.username == email } }
            .compactMap { response -> String? in
                if response.count == 1 {
                    return response.first?.id
                }
                fatalError("User with email address '\(email)' not unique or not found")
            }
            .eraseToAnyPublisher()
    }
}
