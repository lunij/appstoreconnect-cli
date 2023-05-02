// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct ListCapabilitiesOperation: APIOperation {

    struct Options {
        let bundleIdResourceId: String
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> [BundleIdCapability] {
        try await service
            .request(.listBundleIdCapabilitiesForBundleIdV1(id: options.bundleIdResourceId))
            .data
    }
}
