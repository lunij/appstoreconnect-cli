// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine
import Foundation
import SwiftyTextTable

public struct BetaGroup: Codable, Equatable {
    public let id: String?
    public let app: App?
    public let groupName: String?
    public let isInternal: Bool?
    public let publicLink: String?
    public let publicLinkEnabled: Bool?
    public let publicLinkLimit: Int?
    public let publicLinkLimitEnabled: Bool?
    public let creationDate: String?

    public init(
        id: String?,
        app: App?,
        groupName: String?,
        isInternal: Bool?,
        publicLink: String?,
        publicLinkEnabled: Bool?,
        publicLinkLimit: Int?,
        publicLinkLimitEnabled: Bool?,
        creationDate: String?
    ) {
        self.id = id
        self.app = app
        self.groupName = groupName
        self.isInternal = isInternal
        self.publicLink = publicLink
        self.publicLinkEnabled = publicLinkEnabled
        self.publicLinkLimit = publicLinkLimit
        self.publicLinkLimitEnabled = publicLinkLimitEnabled
        self.creationDate = creationDate
    }
}

// MARK: - Extensions

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

extension BetaGroup {
    init(
        _ apiApp: AppStoreConnect_Swift_SDK.App?,
        _ apiBetaGroup: AppStoreConnect_Swift_SDK.BetaGroup
    ) {
        self.init(
            id: apiBetaGroup.id,
            app: apiApp.map(App.init),
            groupName: apiBetaGroup.attributes?.name,
            isInternal: apiBetaGroup.attributes?.isInternalGroup,
            publicLink: apiBetaGroup.attributes?.publicLink,
            publicLinkEnabled: apiBetaGroup.attributes?.publicLinkEnabled,
            publicLinkLimit: apiBetaGroup.attributes?.publicLinkLimit,
            publicLinkLimitEnabled: apiBetaGroup.attributes?.publicLinkLimitEnabled,
            creationDate: apiBetaGroup.attributes?.createdDate?.formattedDate
        )
    }
}
