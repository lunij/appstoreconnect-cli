// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine
import Foundation
import SwiftyTextTable

struct BetaTester: Codable, Equatable {
    var email: String?
    var firstName: String?
    var lastName: String?
    var inviteType: String?
    var betaGroups: [BetaGroup]
    var apps: [App]
}

// MARK: - Extensions

extension BetaTester {
    init(_ output: GetBetaTesterOperation.Output) throws {
        let betaTester = output.betaTester
        let appRelationships = (betaTester.relationships?.apps?.data) ?? []
        let betaGroupRelationships = (betaTester.relationships?.betaGroups?.data) ?? []

        let apps = appRelationships.compactMap { relationship -> AppStoreConnect_Swift_SDK.App? in
            output.apps?.first { app in relationship.id == app.id }
        }

        let betaGroups = betaGroupRelationships.compactMap { relationship -> AppStoreConnect_Swift_SDK.BetaGroup? in
            output.betaGroups?.first { betaGroup in relationship.id == betaGroup.id }
        }

        self.init(
            email: betaTester.attributes?.email,
            firstName: betaTester.attributes?.firstName,
            lastName: betaTester.attributes?.lastName,
            inviteType: betaTester.attributes?.inviteType?.rawValue,
            betaGroups: try betaGroups.map { try BetaGroup(nil, $0) },
            apps: try apps.map(App.init)
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
            betaGroups.compactMap(\.groupName).joined(separator: ", "),
            apps.map(\.bundleId).joined(separator: ", ")
        ]
    }
}
