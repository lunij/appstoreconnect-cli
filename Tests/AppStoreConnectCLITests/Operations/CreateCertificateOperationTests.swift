// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import XCTest
@testable import AppStoreConnectCLI

final class CreateCertificateOperationTests: BaseTestCase {
    func test_createsCertificate_success() async throws {
        mockService.requestReturnValue = CertificateResponse.fake(data: .fake())

        let certificate = try await CreateCertificateOperation(service: mockService, options: .fake()).execute()

        XCTAssertEqual(mockService.calls, [.request(path: "/v1/certificates")])
        XCTAssertEqual(certificate.id, "fakeId")
    }
}

private extension CreateCertificateOperation.Options {
    static func fake(
        certificateType: CertificateType = .iOSDevelopment,
        csrContent: String = "fakeCsrContent"
    ) -> Self {
        .init(certificateType: certificateType, csrContent: csrContent)
    }
}
