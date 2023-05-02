// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct DeleteBetaTestersOperation: APIOperation {

    struct Options {
        let ids: [String]
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws {
        for id in options.ids {
            _ = try await service.request(.deleteBetaTesterV1(id: id))
        }
    }
}
