// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Bagbutik_TestFlight

struct ListBetaTestersUseCase {
    let service: BagbutikServiceProtocol

    func listBetaTesters(
        email: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        inviteType: BetaInviteType? = nil,
        filterIdentifiers: [AppLookupIdentifier] = [],
        groupNames: [String] = [],
        sorts: [ListBetaTestersV1.Sort] = [],
        limit: Int? = nil,
        relatedResourcesLimit: Int? = nil
    ) async throws -> [BetaTester] {
        var filterAppIds: [String] = []
        var filterBundleIds: [String] = []

        filterIdentifiers.forEach { identifier in
            switch identifier {
            case let .appId(filterAppId):
                filterAppIds.append(filterAppId)
            case let .bundleId(filterBundleId):
                filterBundleIds.append(filterBundleId)
            }
        }

        if filterBundleIds.isNotEmpty {
            filterAppIds += try await GetAppsOperation(
                service: service,
                options: .init(bundleIds: filterBundleIds)
            )
            .execute()
            .map(\.id)
        }

        let groupIds = try await groupNames.asyncFlatMap {
            try await ListBetaGroupsOperation(
                service: service,
                options: .init(names: [$0])
            )
            .execute()
            .map(\.betaGroup.id)
        }

        var betaTesters = try await ListBetaTestersOperation(
            service: service,
            options: .init(
                email: email,
                firstName: firstName,
                lastName: lastName,
                inviteType: inviteType,
                appIds: nil, // Specifying app ids in the API request can cause undefined behaviour
                groupIds: groupIds,
                sorts: sorts,
                limit: limit,
                relatedResourcesLimit: relatedResourcesLimit
            )
        )
        .execute()

        if filterAppIds.isNotEmpty {
            betaTesters = betaTesters.filter { betaTester in
                betaTester.relationships?.apps?.data?.contains { filterAppIds.contains($0.id) } ?? false
            }
        }

        return betaTesters.map(BetaTester.init)
    }
}
