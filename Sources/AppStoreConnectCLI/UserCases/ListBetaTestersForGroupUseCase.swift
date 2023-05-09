// Copyright 2023 Itty Bitty Apps Pty Ltd

struct ListBetaTestersForGroupUseCase {
    let service: BagbutikServiceProtocol

    func listBetaTestersForGroup(
        identifier: AppLookupIdentifier,
        groupName: String
    ) async throws -> [BetaTester] {
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
        .map { BetaTester($0, betaGroups: [try .init(betaGroup, app: app)]) }
    }
}
