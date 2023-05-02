// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import Model

struct ListProfilesByBundleIdOperation: APIOperation {

    struct Options {
        let bundleIdResourceId: String
        let limit: Int?
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> [Model.Profile] {
        let profiles = try await service.request(.listProfilesForBundleIdV1(
            id: options.bundleIdResourceId,
            limit: options.limit
        ))
        .data

        return profiles.map { Model.Profile($0) }
    }
}
