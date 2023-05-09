// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models

struct UpdateBuildLocalizationOperation: APIOperation {
    struct Options {
        let localizationId: String
        let whatsNew: String
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> BetaBuildLocalization {
        try await service.request(
            .updateBetaBuildLocalizationV1(
                id: options.localizationId,
                requestBody: .init(data: .init(
                    id: options.localizationId,
                    attributes: .init(whatsNew: options.whatsNew)
                ))
            )
        )
        .data
    }
}
