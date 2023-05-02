// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import CollectionConcurrencyKit

struct InviteTesterOperation: APIOperation {

    enum Error: Swift.Error, CustomStringConvertible {
        case noGroupsExist(groupNames: [String], bundleId: String)
        case noAppExist
        case betaTesterInvitationFailed

        var description: String {
            switch self {
            case let .noGroupsExist(groupNames, bundleId):
                return "One or more of beta groups \"\(groupNames)\" don't exist or don't belong to application with bundle ID \"\(bundleId)\"."
            case .noAppExist:
                return "App with provided bundleId doesn't exist."
            case .betaTesterInvitationFailed:
                return "The beta tester invitation failed"
            }
        }
    }

    struct Options {
        let firstName: String?
        let lastName: String?
        let email: String
        let identifers: GroupIdentifiers

        enum GroupIdentifiers {
            case bundleIdWithGroupNames(bundleId: String, groupNames: [String])
            case resourceId([String])
        }
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> BetaTester {
        let groupIds: [String]

        switch options.identifers {
        case let .bundleIdWithGroupNames(bundleId, groupNames):
            let appId = try await GetAppOperation(
                service: service,
                options: .init(bundleId: bundleId)
            )
            .execute()
            .id

            let betaGroups = try await service
                .request(.listBetaGroupsForAppV1(id: appId))
                .data

            let betaGroupNamesForApp = betaGroups.compactMap { $0.attributes?.name }

            guard Set(groupNames).isSubset(of: Set(betaGroupNamesForApp)) else {
                throw Error.noGroupsExist(
                    groupNames: groupNames,
                    bundleId: bundleId
                )
            }

            groupIds = getGroupIds(in: betaGroups, matching: groupNames)
        case let .resourceId(identifiers):
            groupIds = identifiers
        }

        let betaTesters = try await groupIds.asyncMap { betaGroupId in
            try await service
                .request(.createBetaTesterV1(requestBody: .init(data: .init(attributes: .init(
                    email: options.email,
                    firstName: options.firstName,
                    lastName: options.lastName
                ), relationships: .init(
                    betaGroups: .init(data: [.init(id: betaGroupId)])
                )))))
                .data
        }

        guard let betaTester = betaTesters.first else {
            throw Error.betaTesterInvitationFailed
        }

        return betaTester
    }

    private func getGroupIds(
        in betaGroups: [BetaGroup],
        matching names: [String]
    ) -> [String] {
        betaGroups.filter { betaGroup in
            guard let name = betaGroup.attributes?.name else {
                return false
            }
            return names.contains(name)
        }
        .map { $0.id }
    }

}
