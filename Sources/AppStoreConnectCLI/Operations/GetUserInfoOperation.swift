// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models

struct GetUserInfoOperation: APIOperation {
    enum Error: Swift.Error, CustomStringConvertible, Equatable {
        case userNotFound(email: String)

        var description: String {
            switch self {
            case let .userNotFound(email):
                return "User not found (\(email))"
            }
        }
    }

    struct Options {
        let email: String
        let includeVisibleApps: Bool
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> Bagbutik_Models.User {
        let users = try await service.request(.listUsersV1(
            filters: [.username([options.email])],
            includes: options.includeVisibleApps ? [.visibleApps] : nil
        ))
        .data

        guard let user = users.first else {
            throw Error.userNotFound(email: options.email)
        }

        return user
    }
}
