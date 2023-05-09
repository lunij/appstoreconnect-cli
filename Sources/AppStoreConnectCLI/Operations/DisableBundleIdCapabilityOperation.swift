// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Provisioning

struct DisableBundleIdCapabilityOperation: APIOperation {
    struct Options {
        let capabilityId: String
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws {
        try await service.request(.deleteBundleIdCapabilityV1(id: options.capabilityId))
    }
}
