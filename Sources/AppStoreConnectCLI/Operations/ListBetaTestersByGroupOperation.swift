// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models

struct ListBetaTestersByGroupOperation: APIOperation {
    struct Options {
        let groupId: String
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> [Bagbutik_Models.BetaTester] {
        try await service
            .requestAllPages(.listBetaTestersForBetaGroupV1(id: options.groupId))
            .data
    }
}
