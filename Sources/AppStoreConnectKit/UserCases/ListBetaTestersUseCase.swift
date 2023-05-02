// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import Model

struct ListBetaTestersUseCase {
    let service: BagbutikService

    func listBetaTesters(
        email: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        inviteType: ListBetaTestersV1.Filter.InviteType? = nil,
        filterIdentifiers: [AppLookupIdentifier] = [],
        groupNames: [String] = [],
        sorts: [ListBetaTestersV1.Sort] = [],
        limit: Int? = nil,
        relatedResourcesLimit: Int? = nil
    ) async throws -> [Model.BetaTester] {

        var filterAppIds: [String] = []
        var filterBundleIds: [String] = []

        filterIdentifiers.forEach { identifier in
            switch identifier {
            case .appId(let filterAppId):
                filterAppIds.append(filterAppId)
            case .bundleId(let filterBundleId):
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
                betaTester.relationships?.apps?.data?.first { filterAppIds.contains($0.id) } != nil
            }
        }

        return betaTesters.map(Model.BetaTester.init)
    }
}
