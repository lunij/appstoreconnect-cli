// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import Model
import SwiftyTextTable

// MARK: - API conveniences

extension Model.User {
    enum Error: Swift.Error, CustomStringConvertible {
        case usernameMissing

        var description: String {
            switch self {
            case .usernameMissing:
                return "The user's username is missing"
            }
        }
    }

    static func fromAPIResponse(_ response: Bagbutik.UsersResponse) -> [Model.User] {
        response.data.compactMap { user in
            let userVisibleAppIds = user.relationships?.visibleApps?.data?.compactMap { $0.id }
            let userVisibleApps = response.included?.filter {
                userVisibleAppIds?.contains($0.id) ?? false
            }
            return Model.User(user, visibleApps: userVisibleApps)
        }
    }

    init(_ user: Bagbutik.User, visibleApps: [String]) throws {
        guard
            let attributes = user.attributes,
            let username = user.attributes?.username
        else {
            throw Error.usernameMissing
        }

        let visibleApps = user.relationships?.visibleApps?.data?.map { $0.type }

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

    init(_ user: Bagbutik.User, visibleApps: [Bagbutik.App]? = nil) {
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

// MARK: - TextTable conveniences

extension Model.User: ResultRenderable, TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "Username"),
            TextTableColumn(header: "First Name"),
            TextTableColumn(header: "Last Name"),
            TextTableColumn(header: "Role"),
            TextTableColumn(header: "Provisioning Allowed"),
            TextTableColumn(header: "All Apps Visible"),
            TextTableColumn(header: "Visible Apps"),
        ]
    }

    var tableRow: [CustomStringConvertible] {
        [
            username,
            firstName,
            lastName,
            roles.joined(separator: ", "),
            provisioningAllowed.toYesNo(),
            allAppsVisible.toYesNo(),
            visibleApps?.joined(separator: ", ") ?? "",
        ]
    }
}
