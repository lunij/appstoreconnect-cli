// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct GetBetaTesterOperation: APIOperation {

    struct Options {
        enum TesterIdentifier {
            case id(String)
            case email(String)
        }

        let identifier: TesterIdentifier
        var limitApps: Int?
        var limitBuilds: Int?
        var limitBetaGroups: Int?
    }

    enum Error: Swift.Error, CustomStringConvertible {
        case betaTesterNotFound(String)

        var description: String {
            switch self {
            case .betaTesterNotFound(let email):
                return "Beta tester with provided email '\(email)' doesn't exist."
            }
        }
    }

    let service: BagbutikService
    let options: Options

    private var listTestersLimits: [ListBetaTestersV1.Limit] {
        var limits: [ListBetaTestersV1.Limit] = []

        if let limitApps = options.limitApps {
            limits.append(.apps(limitApps))
        }

        if let limitBuilds = options.limitBuilds {
            limits.append(.builds(limitBuilds))
        }

        if let limitBetaGroups = options.limitBetaGroups {
            limits.append(.betaGroups(limitBetaGroups))
        }

        return limits
    }

    private var getTesterLimits: [GetBetaTesterV1.Limit] {
        var limits: [GetBetaTesterV1.Limit] = []

        if let limitApps = options.limitApps {
            limits.append(.apps(limitApps))
        }

        if let limitBuilds = options.limitBuilds {
            limits.append(.builds(limitBuilds))
        }

        if let limitBetaGroups = options.limitBetaGroups {
            limits.append(.betaGroups(limitBetaGroups))
        }

        return limits
    }

    func execute() async throws -> BetaTester {
        switch options.identifier {
        case let .id(id):
            return try await getBetaTester(id: id)
        case let .email(email):
            return try await getBetaTester(email: email)
        }
    }

    private func getBetaTester(id: String) async throws -> BetaTester {
        try await service.request(.getBetaTesterV1(
            id: id,
            includes: [.betaGroups, .apps],
            limits: getTesterLimits
        ))
        .data
    }

    private func getBetaTester(email: String) async throws -> BetaTester {
        let betaTesters = try await service.request(.listBetaTestersV1(
            filters: [.email([email])],
            includes: [.betaGroups, .apps],
            limits: listTestersLimits
        ))
        .data

        guard let betaTester = betaTesters.first else {
            throw Error.betaTesterNotFound(email)
        }

        return betaTester
    }
}
