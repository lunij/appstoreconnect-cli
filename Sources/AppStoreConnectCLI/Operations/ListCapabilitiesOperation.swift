// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models

struct ListCapabilitiesOperation: APIOperation {
    struct Options {
        let bundleIdResourceId: String
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> [Bagbutik_Models.BundleIdCapability] {
        try await service
            .request(.listBundleIdCapabilitiesForBundleIdV1(id: options.bundleIdResourceId))
            .data
    }
}
