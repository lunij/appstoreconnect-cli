// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct DisableBundleIdCapabilityOperation: APIOperation {

    struct Options {
        let capabilityId: String
    }

    let service: BagbutikService
    let options: Options
    
    func execute() async throws {
        _ = try await service.request(.deleteBundleIdCapabilityV1(id: options.capabilityId))
    }
}
