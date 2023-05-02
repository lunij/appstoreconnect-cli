// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct ListUsersOperation: APIOperation {
    typealias Filter = ListUsersV1.Filter
    typealias FilterRole = ListUsersV1.Filter.Roles
    typealias Include = ListUsersV1.Include
    typealias Limit = ListUsersV1.Limit
    typealias Sort = ListUsersV1.Sort

    struct Options {
        let limitVisibleApps: Int?
        let limitUsers: Int?
        let filterUsername: [String]
        let filterRoles: [FilterRole]
        let filterVisibleApps: [String]
        let includeVisibleApps: Bool
        let sorts: [Sort]
    }

    private var limits: [Limit]? {
        [
            options.limitUsers.map(Limit.limit),
            options.limitVisibleApps.map(Limit.visibleApps)
        ]
        .compactMap { $0 }
        .nilIfEmpty
    }

    private var includes: [Include]? {
        options.includeVisibleApps ? [.visibleApps] : nil
    }

    private var filters: [Filter]? {
        let roles = options.filterRoles.nilIfEmpty.map(Filter.roles)
        let usernames = options.filterUsername.nilIfEmpty.map(Filter.username)
        let visibleApps = options.filterVisibleApps.nilIfEmpty.map(Filter.visibleApps)

        return [roles, usernames, visibleApps].compactMap({ $0 }).nilIfEmpty
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> [(User, [App])] {
        let responses = try await service
            .requestAllPages(.listUsersV1(
                filters: filters,
                includes: includes,
                sorts: options.sorts.nilIfEmpty,
                limits: limits
            ))
            .responses

        return responses.flatMap { response in
            response.data.map { user in
                (user, response.included ?? [])
            }
        }
    }
}

