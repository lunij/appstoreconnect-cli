// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import Model

struct ListBetaTestersForGroupUseCase {
    let service: BagbutikService

    func listBetaTestersForGroup(
        identifier: AppLookupIdentifier,
        groupName: String
    ) async throws -> [Model.BetaTester] {
        let app = try await ReadAppOperation(
            service: service,
            options: .init(identifier: identifier)
        )
        .execute()

        let betaGroup = try await GetBetaGroupOperation(
            service: service,
            options: .init(appId: app.id, bundleId: nil, betaGroupName: groupName)
        )
        .execute()

        return try await ListBetaTestersByGroupOperation(
            service: service,
            options: .init(groupId: betaGroup.id)
        )
        .execute()
        .map { Model.BetaTester($0, betaGroups: [.init(betaGroup, app: app)]) }
    }
}
