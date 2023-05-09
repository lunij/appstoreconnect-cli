// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Bagbutik_Provisioning
import XCTest
@testable import AppStoreConnectCLI

final class ListCertificateOperationsTests: XCTestCase {
    func test_certificateNotFound() async throws {
        let service = BagbutikServiceMock { _, _ in
            (try Fixture(named: "v1/certificates/no_certificate").data, HTTPURLResponse.fake())
        }

        let error: ListCertificatesOperation.Error? = try await catchError {
            _ = try await ListCertificatesOperation(service: service, options: .fake()).execute()
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
