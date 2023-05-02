// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct ModifyBundleIdOperation: APIOperation {
    
    struct Options {
        let resourceId: String
        let name: String
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> BundleId {
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
