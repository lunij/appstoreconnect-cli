// Copyright 2023 Itty Bitty Apps Pty Ltd

struct DeleteBetaGroupOperation: APIOperation {
    struct Options {
        let betaGroupId: String
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws {
        try await service.request(.deleteBetaGroupV1(id: options.betaGroupId))
    }
}
