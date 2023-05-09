// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import SwiftyTextTable

struct BetaGroup: Codable, Equatable {
    let id: String
    let app: App?
    let groupName: String?
    let isInternal: Bool?
    let publicLink: String?
    let publicLinkEnabled: Bool?
    let publicLinkLimit: Int?
    let publicLinkLimitEnabled: Bool?
    let creationDate: String?
}

// MARK: - Extensions

extension BetaGroup {
    init(
        _ betaGroup: Bagbutik_Models.BetaGroup,
        app: Bagbutik_Models.App?
    ) throws {
        self.init(
            id: betaGroup.id,
            app: try app.map(App.init),
            groupName: betaGroup.attributes?.name,
            isInternal: betaGroup.attributes?.isInternalGroup,
            publicLink: betaGroup.attributes?.publicLink,
            publicLinkEnabled: betaGroup.attributes?.publicLinkEnabled,
            publicLinkLimit: betaGroup.attributes?.publicLinkLimit,
            publicLinkLimitEnabled: betaGroup.attributes?.publicLinkLimitEnabled,
            creationDate: betaGroup.attributes?.createdDate?.formattedDate
        )
    }

    init(
        _ betaGroup: Bagbutik_Models.BetaGroup,
        _ includes: [Bagbutik_Models.BetaGroupsResponse.Included]
    ) throws {
        var app: Bagbutik_Models.App?

        for include in includes {
            switch include {
            case let .app(value):
                app = value
            default:
                break
            }
        }

        self.init(
            id: betaGroup.id,
            app: try app.map(App.init),
            groupName: betaGroup.attributes?.name,
            isInternal: betaGroup.attributes?.isInternalGroup,
            publicLink: betaGroup.attributes?.publicLink,
            publicLinkEnabled: betaGroup.attributes?.publicLinkEnabled,
            publicLinkLimit: betaGroup.attributes?.publicLinkLimit,
            publicLinkLimitEnabled: betaGroup.attributes?.publicLinkLimitEnabled,
            creationDate: betaGroup.attributes?.createdDate?.formattedDate
        )
    }
}

extension BetaGroup: ResultRenderable {}

extension BetaGroup: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "App ID"),
            TextTableColumn(header: "App Bundle ID"),
            TextTableColumn(header: "App Name"),
            TextTableColumn(header: "Group Name"),
            TextTableColumn(header: "Is Internal"),
            TextTableColumn(header: "Public Link"),
            TextTableColumn(header: "Public Link Enabled"),
            TextTableColumn(header: "Public Link Limit"),
            TextTableColumn(header: "Public Link Limit Enabled"),
            TextTableColumn(header: "Creation Date")
        ]
    }

    var tableRow: [CustomStringConvertible] {
        [
            app?.id ?? "",
            app?.bundleId ?? "",
            app?.name ?? "",
            groupName ?? "",
            isInternal ?? "",
            publicLink ?? "",
            publicLinkEnabled ?? "",
            publicLinkLimit ?? "",
            publicLinkEnabled ?? "",
            creationDate ?? ""
        ]
    }
}
