// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models

struct CreateBuildLocalizationOperation: APIOperation {
    struct Options {
        let buildId: String
        let locale: String
        let whatsNew: String
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> BetaBuildLocalization {
        try await service.request(.createBetaBuildLocalizationV1(
            requestBody: .init(data: .init(
                attributes: .init(
                    locale: options.locale,
                    whatsNew: options.whatsNew
                ),
                relationships: .init(build: .init(data: .init(id: options.buildId)))
            ))
        ))
        .data
    }
}
