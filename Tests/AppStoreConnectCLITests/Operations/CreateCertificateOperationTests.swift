// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Foundation
import XCTest
@testable import AppStoreConnectCLI

final class CreateCertificateOperationTests: XCTestCase {
    let options = CreateCertificateOperation.Options(
        certificateType: .iOSDevelopment,
        csrContent: ""
    )

    func testExecute_success() async throws {
        let service = BagbutikServiceMock { _, _ in
            (try Fixture(named: "v1/certificates/created_success").data, HTTPURLResponse.fake())
        }

        let operation = CreateCertificateOperation(service: service, options: options)
        let certificate = try await operation.execute()

        XCTAssertEqual(certificate.attributes?.name, "Mac Installer Distribution: Hello")
        XCTAssertEqual(certificate.attributes?.platform, .macOS)
        XCTAssertEqual(certificate.attributes?.certificateContent, "MIIFpDCCBIygAwIBAgIIbgb/7NS42MgwDQ")
    }
}
