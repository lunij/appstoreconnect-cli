// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models

struct ModifyBundleIdOperation: APIOperation {
    struct Options {
        let resourceId: String
        let name: String
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> Bagbutik_Models.BundleId {
        try await service.request(
            .updateBundleIdV1(
                id: options.resourceId,
                requestBody: .init(
                    data: .init(
                        id: options.resourceId,
                        attributes: .init(name: options.name)
                    )
                )
            )
        )
        .data
    }
}
