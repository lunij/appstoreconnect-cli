// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct RegisterBundleIdOperation: APIOperation {
    struct Options {
        let bundleId: String
        let name: String
        let platform: BundleIdPlatform
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> BundleId {
        try await service.request(
            .createBundleIdV1(requestBody: .init(data: .init(attributes: .init(
                identifier: options.bundleId,
                name: options.name,
                platform: options.platform
            ))))
        ).data
    }
}
