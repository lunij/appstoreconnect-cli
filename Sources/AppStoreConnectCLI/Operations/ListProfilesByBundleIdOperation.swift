// Copyright 2023 Itty Bitty Apps Pty Ltd

struct ListProfilesByBundleIdOperation: APIOperation {
    struct Options {
        let bundleIdResourceId: String
        let limit: Int?
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> [Profile] {
        let profiles = try await service.request(.listProfilesForBundleIdV1(
            id: options.bundleIdResourceId,
            limit: options.limit
        ))
        .data

        return profiles.map { .init($0) }
    }
}
