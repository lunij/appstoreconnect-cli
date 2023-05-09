// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models

struct RegisterBundleIdOperation: APIOperation {
    struct Options {
        let bundleId: String
        let name: String
        let platform: BundleIdPlatform
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> Bagbutik_Models.BundleId {
        try await service.request(
            .createBundleIdV1(requestBody: .init(data: .init(attributes: .init(
                identifier: options.bundleId,
                name: options.name,
                platform: options.platform
            ))))
        ).data
    }
}
