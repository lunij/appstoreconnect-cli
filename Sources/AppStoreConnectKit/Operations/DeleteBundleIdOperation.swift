// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct DeleteBundleIdOperation: APIOperation {

    struct Options {
        let resourceId: String
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws {
        _ = try await service.request(.deleteBundleIdV1(id: options.resourceId))
    }
}
