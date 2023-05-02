// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import Model
import SwiftyTextTable

extension Model.BetaGroup {
    init(
        _ betaGroup: Bagbutik.BetaGroup,
        app: Bagbutik.App?
    ) {
        self.init(
            id: betaGroup.id,
            app: app.map(Model.App.init),
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
        _ betaGroup: Bagbutik.BetaGroup,
        _ includes: [Bagbutik.BetaGroupsResponse.Included]
    ) {
        var app: Bagbutik.App?

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
            app: app.map(Model.App.init),
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


extension Model.BetaGroup: TableInfoProvider, ResultRenderable {

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
            TextTableColumn(header: "Creation Date"),
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
            creationDate ?? "",
        ]
    }
}
