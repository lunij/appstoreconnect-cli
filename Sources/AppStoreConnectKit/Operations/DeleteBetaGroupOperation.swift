// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct DeleteBetaGroupOperation: APIOperation {
    struct Options {
        let betaGroupId: String
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws {
        _ = try await service.request(.deleteBetaGroupV1(id: options.betaGroupId))
    }
}
