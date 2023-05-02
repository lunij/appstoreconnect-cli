// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct GetAppOperation: APIOperation {

    struct Options {
        let bundleId: String
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> App {
        try await service
            .request(.getAppForBundleIdV1(id: options.bundleId))
            .data
    }
}
