// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Bagbutik_TestFlight

struct ListBetaTestersOperation: APIOperation {
    struct Options {
        var email: String?
        var firstName: String?
        var lastName: String?
        var inviteType: BetaInviteType?
        var appIds: [String]?
        var groupIds: [String]?
        var sorts: [ListBetaTestersV1.Sort] = []
        var limit: Int?
        var relatedResourcesLimit: Int?
    }

    enum Error: Swift.Error, CustomStringConvertible {
        case betaTestersNotFound

        var description: String {
            switch self {
            case .betaTestersNotFound:
                return "Beta testers not found"
            }
        }
    }

    let service: BagbutikServiceProtocol
    let options: Options

    var limits: [ListBetaTestersV1.Limit] {
        var limits: [ListBetaTestersV1.Limit] = []

        if let resourcesLimit = options.relatedResourcesLimit {
            limits.append(.apps(resourcesLimit))
            limits.append(.betaGroups(resourcesLimit))
        }

        if let limit = options.limit {
            limits.append(.limit(limit))
        }

        return limits
    }

    var filters: [ListBetaTestersV1.Filter] {
        var filters: [ListBetaTestersV1.Filter] = []

        if let firstName = options.firstName {
            filters.append(.firstName([firstName]))
        }

        if let lastName = options.lastName {
            filters.append(.lastName([lastName]))
        }

        if let email = options.email {
            filters.append(.email([email]))
        }

        if let inviteType = options.inviteType {
            filters.append(.inviteType([inviteType]))
        }

        if let appIds = options.appIds, !appIds.isEmpty {
            filters.append(.apps(appIds))
        }

        if let groupIds = options.groupIds, !groupIds.isEmpty {
            filters.append(.betaGroups(groupIds))
        }

        return filters
    }

    func execute() async throws -> [Bagbutik_Models.BetaTester] {
        let betaTesters = try await service
            .requestAllPages(.listBetaTestersV1(
                filters: filters,
                includes: [.apps, .betaGroups],
                sorts: options.sorts,
                limits: limits
            ))
            .data

        guard betaTesters.isNotEmpty else {
            throw Error.betaTestersNotFound
        }

        return betaTesters
    }
}
