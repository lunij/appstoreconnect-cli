// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct DeleteBuildLocalizationOperation: APIOperation {
    struct Options {
        let localizationId: String
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws {
        _ = try await service.request(.deleteBetaBuildLocalizationV1(id: options.localizationId))
    }
}
