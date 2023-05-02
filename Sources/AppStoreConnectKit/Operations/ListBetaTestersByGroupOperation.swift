// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct ListBetaTestersByGroupOperation: APIOperation {

    struct Options {
        let groupId: String
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> [BetaTester] {
        try await service
            .requestAllPages(.listBetaTestersForBetaGroupV1(id: options.groupId))
            .data
    }
}
