// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models

struct GetAppOperation: APIOperation {
    struct Options {
        let bundleId: String
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> Bagbutik_Models.App {
        try await service
            .request(.getAppForBundleIdV1(id: options.bundleId))
            .data
    }
}
