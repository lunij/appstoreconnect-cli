// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import SwiftyTextTable

struct BetaTester: Codable, Equatable {
    var email: String?
    var firstName: String?
    var lastName: String?
    var inviteType: String?
    var betaGroups: [BetaGroup]?
}

// MARK: - Extensions

extension BetaTester {
    var apps: [App]? {
        betaGroups?.compactMap(\.app)
    }
}

extension BetaTester {
    init(_ betaTester: Bagbutik_Models.BetaTester) {
        self.init(betaTester, betaGroups: nil)
    }

    init(
        _ betaTester: Bagbutik_Models.BetaTester,
        betaGroups: [BetaGroup]?
    ) {
        self.init(
            email: betaTester.attributes?.email,
            firstName: betaTester.attributes?.firstName,
            lastName: betaTester.attributes?.lastName,
            inviteType: betaTester.attributes?.inviteType?.rawValue,
            betaGroups: betaGroups?.nilIfEmpty
        )
    }
}

extension BetaTester: ResultRenderable {}

extension BetaTester: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "Email"),
            TextTableColumn(header: "First Name"),
            TextTableColumn(header: "Last Name"),
            TextTableColumn(header: "Invite Type"),
            TextTableColumn(header: "Beta Groups"),
            TextTableColumn(header: "Apps")
        ]
    }

    var tableRow: [CustomStringConvertible] {
        [
            email ?? "",
            firstName ?? "",
            lastName ?? "",
            inviteType ?? "",
            betaGroups?.compactMap(\.groupName).joined(separator: ", ") ?? "",
            apps?.map(\.bundleId).joined(separator: ", ") ?? ""
        ]
    }
}
