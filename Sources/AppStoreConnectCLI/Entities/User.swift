// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import SwiftyTextTable

struct User: Codable, Equatable {
    let username: String
    let firstName: String
    let lastName: String
    let roles: [String]
    let provisioningAllowed: Bool
    let allAppsVisible: Bool
    let visibleApps: [String]?
}

// MARK: - Extensions

extension User {
    enum Error: Swift.Error, CustomStringConvertible {
        case usernameMissing

        var description: String {
            switch self {
            case .usernameMissing:
                return "The user's username is missing"
            }
        }
    }

    static func fromAPIResponse(_ response: Bagbutik_Models.UsersResponse) -> [User] {
        response.data.compactMap { user in
            let userVisibleAppIds = user.relationships?.visibleApps?.data?.map(\.id)
            let userVisibleApps = response.included?.filter {
                userVisibleAppIds?.contains($0.id) ?? false
            }
            return User(user, visibleApps: userVisibleApps)
        }
    }

    init(_ user: Bagbutik_Models.User, visibleApps _: [String]) throws {
        guard
            let attributes = user.attributes,
            let username = user.attributes?.username
        else {
            throw Error.usernameMissing
        }

        let visibleApps = user.relationships?.visibleApps?.data?.map(\.type)

        self.init(
            username: username,
            firstName: attributes.firstName ?? "",
            lastName: attributes.lastName ?? "",
            roles: attributes.roles?.map(\.rawValue) ?? [],
            provisioningAllowed: attributes.provisioningAllowed ?? false,
            allAppsVisible: attributes.allAppsVisible ?? false,
            visibleApps: visibleApps
        )
    }

    init(_ user: Bagbutik_Models.User, visibleApps: [Bagbutik_Models.App]? = nil) {
        let attributes = user.attributes
        self.init(
            username: attributes?.username ?? "",
            firstName: attributes?.firstName ?? "",
            lastName: attributes?.lastName ?? "",
            roles: attributes?.roles?.map(\.rawValue) ?? [],
            provisioningAllowed: attributes?.provisioningAllowed ?? false,
            allAppsVisible: attributes?.allAppsVisible ?? false,
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
