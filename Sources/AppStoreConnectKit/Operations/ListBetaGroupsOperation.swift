// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct ListBetaGroupsOperation: APIOperation {

    struct Options {
        var appIds: [String] = []
        var names: [String] = []
        var sorts: [ListBetaGroupsV1.Sort] = []
        var excludeInternal: Bool?
    }

    enum Error: Swift.Error, CustomStringConvertible {
        case missingAppData(BetaGroup)

        var description: String {
            switch self {
            case .missingAppData(let betaGroup):
                return "Missing app data for beta group: \(betaGroup)"
            }
        }
    }

    typealias Output = [(betaGroup: BetaGroup, includes: [BetaGroupsResponse.Included])]

    let service: BagbutikService
    let options: Options

    func execute() async throws -> Output {
        var filters: [ListBetaGroupsV1.Filter] = []
        filters += options.appIds.isEmpty ? [] : [.app(options.appIds)]
        filters += options.names.isEmpty ? [] : [.name(options.names)]

        if let excludeInternal = options.excludeInternal, excludeInternal {
            filters += [.isInternalGroup(["\(!excludeInternal)"])]
        }

        let responses = try await service
            .requestAllPages(.listBetaGroupsV1(
                filters: filters,
                includes: [.app],
                sorts: options.sorts.nilIfEmpty
            ))
            .responses

        return responses.flatMap { response in
            response.data.map { betaGroup in
                (betaGroup, response.included ?? [])
            }
        }
    }
}
