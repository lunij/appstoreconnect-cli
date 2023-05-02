// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct ListUserInvitationsOperation: APIOperation {

    struct Options {
        let filterEmail: [String]
        let filterRole: [ListUserInvitationsV1.Filter.Roles]
        let includeVisibleApps: Bool
        let limitVisibleApps: Int?
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> [UserInvitation] {
        var filters: [ListUserInvitationsV1.Filter] = []

        if options.filterEmail.isNotEmpty { filters.append(.email(options.filterEmail)) }
        if options.filterRole.isNotEmpty { filters.append(.roles(options.filterRole)) }

        let limits = options.limitVisibleApps.map { [ListUserInvitationsV1.Limit.visibleApps($0)] }

        return try await service
            .requestAllPages(.listUserInvitationsV1(filters: filters, limits: limits))
            .data
    }
}

