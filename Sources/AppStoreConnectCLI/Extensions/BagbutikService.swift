// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_AppStore
import Bagbutik_Core

protocol BagbutikServiceProtocol {
    func request<T: Decodable>(_ request: Request<T, ErrorResponse>) async throws -> T
    @discardableResult func request(_ request: Request<EmptyResponse, ErrorResponse>) async throws -> EmptyResponse
    func requestAllPages<T: Decodable & PagedResponse>(_ request: Request<T, ErrorResponse>) async throws -> (responses: [T], data: [T.Data])
}

extension BagbutikService: BagbutikServiceProtocol {}

extension BagbutikServiceProtocol {
    /// Find the opaque internal identifier for an application that related to this bundle ID.
    func appResourceIdsForBundleIds(_ bundleIds: [String]) async throws -> [String] {
        try await requestAllPages(.listAppsV1(filters: [.bundleId(bundleIds)])).data.map(\.id)
    }

    func buildIdAndGroupIdsFrom(
        bundleId: String,
        version: String,
        buildNumber: String,
        groupNames: [String]
    ) async throws -> (buildId: String, groupIds: [String]) {
        let appId = try await ReadAppOperation(
            service: self,
            options: .init(identifier: .bundleId(bundleId))
        )
        .execute()
        .id

        let buildId = try await ReadBuildOperation(
            service: self,
            options: .init(
                appId: appId,
                buildNumber: buildNumber,
                preReleaseVersion: version
            )
        )
        .execute()
        .build
        .id

        let groupIds = try await ListBetaGroupsOperation(
            service: self,
            options: .init()
        )
        .execute()
        .filter {
            guard let groupName = $0.betaGroup.attributes?.name else {
                return false
            }
            return $0.betaGroup.relationships?.app?.data?.id == appId && groupNames.contains(groupName)
        }
        .map(\.betaGroup.id)

        return (buildId, groupIds)
    }

    func buildIdFrom(
        bundleId: String,
        buildNumber: String,
        preReleaseVersion: String
    ) async throws -> String {
        let appId = try await ReadAppOperation(
            service: self,
            options: .init(identifier: .bundleId(bundleId))
        )
        .execute()
        .id

        return try await ReadBuildOperation(
            service: self,
            options: .init(
                appId: appId,
                buildNumber: buildNumber,
                preReleaseVersion: preReleaseVersion
            )
        )
        .execute()
        .build
        .id
    }

    func getTestFlightProgram(bundleIds: [String] = []) async throws -> TestFlightProgram {
        let apps = try await ListAppsOperation(service: self, options: .init(bundleIds: bundleIds))
            .execute()

        let betaTesters = try await ListBetaTestersOperation(service: self, options: .init(limit: 200))
            .execute()

        let betaGroups = try await ListBetaGroupsOperation(service: self, options: .init(appIds: apps.map(\.id)))
            .execute()
            .map(BetaGroup.init)

        let betaTestersMapped = betaTesters.map { betaTester in
            let betaGroups: [BetaGroup]? = betaTester.relationships?.betaGroups?.data?.compactMap { betaGroup in
                betaGroups.first { $0.id == betaGroup.id }
            }

            return BetaTester(betaTester, betaGroups: betaGroups)
        }

        return TestFlightProgram(
            apps: try apps.map(App.init),
            betaGroups: betaGroups,
            betaTesters: betaTestersMapped
        )
    }
}
