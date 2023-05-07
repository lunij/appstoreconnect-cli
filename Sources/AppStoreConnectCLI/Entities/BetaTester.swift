// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine
import Foundation
import SwiftyTextTable

public struct BetaTester: Codable, Equatable {
    public var email: String?
    public var firstName: String?
    public var lastName: String?
    public var inviteType: String?
    public var betaGroups: [BetaGroup]
    public var apps: [App]

    public init(
        email: String?,
        firstName: String?,
        lastName: String?,
        inviteType: String?,
        betaGroups: [BetaGroup]?,
        apps: [App]?
    ) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.inviteType = inviteType
        self.betaGroups = betaGroups ?? []
        self.apps = apps ?? []
    }
}

// MARK: - Extensions

extension BetaTester {
    init(_ output: GetBetaTesterOperation.Output) {
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
            betaGroups: betaGroups.map { BetaGroup(nil, $0) },
            apps: apps.map(App.init)
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
            apps.compactMap(\.bundleId).joined(separator: ", ")
        ]
    }
}
