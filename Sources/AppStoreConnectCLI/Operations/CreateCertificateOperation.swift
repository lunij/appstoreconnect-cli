// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Foundation

struct CreateCertificateOperation: APIOperation {
    struct Options {
        let certificateType: CertificateType
        let csrContent: String
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> Bagbutik_Models.Certificate {
        let body = CertificateCreateRequest(
            data: .init(
                attributes: .init(
                    certificateType: options.certificateType,
                    csrContent: options.csrContent
                )
            )
        )

        return try await service.request(.createCertificateV1(requestBody: body)).data
    }
}
