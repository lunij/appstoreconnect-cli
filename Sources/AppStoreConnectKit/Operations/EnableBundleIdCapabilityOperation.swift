// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct EnableBundleIdCapabilityOperation: APIOperation {

    struct Options {
        let bundleIdResourceId: String
        let capabilityType: CapabilityType
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> BundleIdCapability {
        try await service
            .request(.createBundleIdCapabilityV1(requestBody: .init(data: .init(
                attributes: .init(capabilityType: options.capabilityType),
                relationships: .init(bundleId: .init(data: .init(id: options.bundleIdResourceId)))
            ))))
            .data
    }
}
