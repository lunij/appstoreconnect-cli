// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct ModifyUserOperation: APIOperation {

    struct Options {
        let userId: String
        let allAppsVisible: Bool
        let provisioningAllowed: Bool
        let roles: [UserRole]
        let appsVisibleIds: [String]
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> User {
        try await service.request(.updateUserV1(id: options.userId, requestBody: .init(data: .init(
            id: options.userId,
            attributes: .init(
                allAppsVisible: options.allAppsVisible,
                provisioningAllowed: options.provisioningAllowed,
                roles: options.roles
            ),
            relationships: .init(visibleApps: .init(data: options.appsVisibleIds.map { .init(id: $0) }))
        ))))
        .data
    }
}
