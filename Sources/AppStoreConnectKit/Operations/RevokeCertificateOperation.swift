// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct RevokeCertificatesOperation: APIOperation {

    struct Options {
        let ids: [String]
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws {
        for id in options.ids {
            _ = try await service.request(.deleteCertificateV1(id: id))
        }
    }
}
