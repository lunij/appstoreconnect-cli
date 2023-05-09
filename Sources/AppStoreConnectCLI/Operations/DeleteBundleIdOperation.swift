// Copyright 2023 Itty Bitty Apps Pty Ltd

struct DeleteBundleIdOperation: APIOperation {
    struct Options {
        let resourceId: String
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws {
        try await service.request(.deleteBundleIdV1(id: options.resourceId))
    }
}
