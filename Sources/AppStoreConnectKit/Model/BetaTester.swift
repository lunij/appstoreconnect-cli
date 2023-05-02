// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import Model
import SwiftyTextTable

extension Model.BetaTester {
    init(_ betaTester: Bagbutik.BetaTester) {
        self.init(betaTester, betaGroups: nil)
    }

    init(
        _ betaTester: Bagbutik.BetaTester,
        betaGroups: [Model.BetaGroup]?
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

extension Model.BetaTester: ResultRenderable, TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
       return [
            TextTableColumn(header: "Email"),
            TextTableColumn(header: "First Name"),
            TextTableColumn(header: "Last Name"),
            TextTableColumn(header: "Invite Type"),
            TextTableColumn(header: "Beta Groups"),
            TextTableColumn(header: "Apps"),
        ]
    }

    var tableRow: [CustomStringConvertible] {
        return [
            email ?? "",
            firstName ?? "",
            lastName ?? "",
            inviteType ?? "",
            betaGroups?.compactMap(\.groupName).joined(separator: ", ") ?? "",
            apps?.compactMap(\.bundleId).joined(separator: ", ") ?? "",
        ]
    }
}
