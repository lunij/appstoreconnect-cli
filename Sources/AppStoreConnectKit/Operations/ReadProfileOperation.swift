// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import Model

struct ReadProfileOperation: APIOperation {

    struct Options {
        let id: String
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> Model.Profile {
        let response = try await service.request(
            .getProfileV1(
                id: options.id,
                includes: [.bundleId, .certificates, .devices]
            )
        )

        return Model.Profile(response.data, includes: response.included ?? [])
    }
}
