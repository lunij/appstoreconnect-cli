// Copyright 2023 Itty Bitty Apps Pty Ltd

struct DeleteBuildLocalizationOperation: APIOperation {
    struct Options {
        let localizationId: String
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws {
        try await service.request(.deleteBetaBuildLocalizationV1(id: options.localizationId))
    }
}
