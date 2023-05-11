// Copyright 2023 Itty Bitty Apps Pty Ltd

import XCTest
@testable import AppStoreConnectCLI

final class ReadCertificateOperationTests: BaseTestCase {
    func test_execute_success() async throws {
        let mockService = BagbutikServiceOverrideMock { _, _ in
            (try Fixture(named: "v1/certificates/read_certificate_success").data, HTTPURLResponse.fake())
        }

        let certificate = try await ReadCertificateOperation(service: mockService, options: .fake).execute()

        XCTAssertEqual(certificate.name, "Mac Installer Distribution: Hello")
        XCTAssertEqual(certificate.platform, "MAC_OS")
        XCTAssertEqual(certificate.content, "MIIFpDCCBIygAwIBAgIIbgb/7NS42MgwDQ")
    }

    func test_execute_propagatesUpstreamErrors() async throws {
        let mockService = BagbutikServiceOverrideMock { _, _ in
            throw FakeError()
        }

        let error: FakeError? = try await catchError {
            _ = try await ReadCertificateOperation(service: mockService, options: .fake).execute()
        }

        XCTAssertNotNil(error)
    }

    func test_certificateNotFound() async throws {
        mockService.requestReturnValue = CertificatesResponse.fake(data: [])

        let catchedError: ReadCertificateOperation.Error? = try await catchError {
            _ = try await ReadCertificateOperation(service: mockService, options: .fake).execute()
        }

        XCTAssertEqual(catchedError, .certificateNotFound("fakeSerialNumber"))
    }

    func test_multipleCertificatesFound() async throws {
        mockService.requestReturnValue = CertificatesResponse.fake(data: [.fake(), .fake()])

        let catchedError: ReadCertificateOperation.Error? = try await catchError {
            _ = try await ReadCertificateOperation(service: mockService, options: .fake).execute()
        }

        XCTAssertEqual(catchedError, .multipleCertificatesFound("fakeSerialNumber"))
    }
}

private extension ReadCertificateOperation.Options {
    static var fake = Self(serial: "fakeSerialNumber")
}
