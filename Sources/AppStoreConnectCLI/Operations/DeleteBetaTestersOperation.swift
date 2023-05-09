// Copyright 2023 Itty Bitty Apps Pty Ltd

struct DeleteBetaTestersOperation: APIOperation {
    struct Options {
        let ids: [String]
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws {
        for id in options.ids {
            try await service.request(.deleteBetaTesterV1(id: id))
        }
    }
}
