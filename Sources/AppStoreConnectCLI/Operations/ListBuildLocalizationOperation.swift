// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Bagbutik_TestFlight

struct ListBuildLocalizationOperation: APIOperation {
    struct Options {
        let id: String
        let limit: Int?
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> [BetaBuildLocalization] {
        if options.limit == nil {
            return try await service
                .requestAllPages(.listBetaBuildLocalizationsForBuildV1(id: options.id))
                .data
        }

        return try await service
            .request(.listBetaBuildLocalizationsForBuildV1(
                id: options.id,
                limit: options.limit
            ))
            .data
    }
}
