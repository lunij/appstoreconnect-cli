// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct ExpireBuildOperation: APIOperation {

    struct Options {
        let buildId: String
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws {
        _ = try await service.request(.updateBuildV1(id: options.buildId, requestBody: .init(data: .init(
            id: options.buildId,
            attributes: .init(
                expired: true,
                usesNonExemptEncryption: nil
            )
        ))))
    }
}
