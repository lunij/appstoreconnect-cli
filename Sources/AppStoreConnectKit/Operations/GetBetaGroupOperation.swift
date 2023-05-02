// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct GetBetaGroupOperation: APIOperation {

    struct Options {
        let appId: String?
        let bundleId: String?
        let betaGroupName: String
    }

    enum Error: Swift.Error, CustomStringConvertible, Equatable {
        case betaGroupNotFound(groupName: String, bundleId: String, appId: String)

        var description: String {
            switch self {
            case let .betaGroupNotFound(groupName, bundleId, appId):
                return "Beta group not found with the name '\(groupName)', the bundle id '\(bundleId)' and the app id '\(appId)'"
            }
        }
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> BetaGroup {
        let betaGroupName = options.betaGroupName
        let bundleId = options.bundleId ?? ""
        let appId = options.appId ?? ""

        var filters: [ListBetaGroupsV1.Filter] = [.name([betaGroupName])]
        filters += appId.isEmpty ? [] : [.app([appId])]

        let betaGroups = try await service
            .request(.listBetaGroupsV1(filters: filters))
            .data

        guard let betaGroup = betaGroups.first(where: { $0.attributes?.name == betaGroupName }) else {
            throw Error.betaGroupNotFound(groupName: betaGroupName, bundleId: bundleId, appId: appId)
        }

        return betaGroup
    }
}
