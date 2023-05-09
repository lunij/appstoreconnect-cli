// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import XCTest
@testable import AppStoreConnectCLI

final class ReadCertificateOperationTests: XCTestCase {
    func test_execute_success() async throws {
        let mockService = BagbutikServiceMock { _, _ in
            (try Fixture(named: "v1/certificates/read_certificate_success").data, HTTPURLResponse.fake())
        }

        let certificate = try await ReadCertificateOperation(service: mockService, options: .fake).execute()

        XCTAssertEqual(certificate.name, "Mac Installer Distribution: Hello")
        XCTAssertEqual(certificate.platform, BundleIdPlatform.macOS.rawValue)
        XCTAssertEqual(certificate.content, "MIIFpDCCBIygAwIBAgIIbgb/7NS42MgwDQ")
    }

    func test_execute_propagatesUpstreamErrors() async throws {
        let mockService = BagbutikServiceMock { _, _ in
            throw FakeError()
        }

        let error: FakeError? = try await catchError {
            _ = try await ReadCertificateOperation(service: mockService, options: .fake).execute()
        }

        XCTAssertNotNil(error)
    }

    func test_certificateNotFound() async throws {
        let mockService = BagbutikServiceMock { _, _ in
            (try Fixture(named: "v1/certificates/no_certificate").data, HTTPURLResponse.fake())
        }

        let catchedError: ReadCertificateOperation.Error? = try await catchError {
            _ = try await ReadCertificateOperation(service: mockService, options: .fake).execute()
        }

        XCTAssertEqual(catchedError, .certificateNotFound("fakeSerialNumber"))
    }

    func test_multipleCertificatesFound() async throws {
        let mockService = BagbutikServiceMock { _, _ in
            (try Fixture(named: "v1/certificates/not_unique").data, HTTPURLResponse.fake())
        }

        let catchedError: ReadCertificateOperation.Error? = try await catchError {
            _ = try await ReadCertificateOperation(service: mockService, options: .fake).execute()
        }

        XCTAssertEqual(catchedError, .multipleCertificatesFound("fakeSerialNumber"))
    }
}

private extension ReadCertificateOperation.Options {
    static var fake = Self(serial: "fakeSerialNumber")
}
