// Copyright 2023 Itty Bitty Apps Pty Ltd

struct RevokeCertificatesOperation: APIOperation {
    struct Options {
        let ids: [String]
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws {
        for id in options.ids {
            try await service.request(.deleteCertificateV1(id: id))
        }
    }
}
