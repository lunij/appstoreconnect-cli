// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Bagbutik_Provisioning
import XCTest
@testable import AppStoreConnectCLI

final class ListCertificateOperationsTests: BaseTestCase {
    func test_certificateNotFound() async throws {
        mockService.requestAllPagesResponses = [CertificatesResponse.fake(data: [])]

        let error: ListCertificatesOperation.Error? = try await catchError {
            _ = try await ListCertificatesOperation(service: mockService, options: .fake()).execute()
        }

        XCTAssertEqual(error, .certificatesNotFound)
    }
}

private extension ListCertificatesOperation.Options {
    static func fake(
        filterSerial: String? = nil,
        sorts: [ListCertificatesV1.Sort]? = nil,
        filterType: CertificateType? = nil,
        filterDisplayName: String? = nil,
        limit: Int? = nil
    ) -> Self {
        .init(
            filterSerial: filterSerial,
            sorts: sorts,
            filterType: filterType,
            filterDisplayName: filterDisplayName,
            limit: limit
        )
    }
}
