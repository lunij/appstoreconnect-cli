// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import XCTest
@testable import AppStoreConnectCLI

final class ReadPreReleaseVersionOperationTests: BaseTestCase {
    func test_onePreReleaseVersion() async throws {
        mockService.requestReturnValue = PreReleaseVersionsResponse.fake(data: [.fake(attributes: .init(version: "1.0"))])

        let response = try await ReadPreReleaseVersionOperation(
            service: mockService,
            options: .init()
        )
        .execute()

        XCTAssertEqual(mockService.calls, [.request(path: "/v1/preReleaseVersions")])
        XCTAssertEqual(response.data.first?.attributes?.version, "1.0")
    }

    func test_noPreReleaseVersion() async throws {
        mockService.requestReturnValue = PreReleaseVersionsResponse.fake(data: [])

        let error: ReadPreReleaseVersionOperation.Error? = try await catchError {
            _ = try await ReadPreReleaseVersionOperation(
                service: mockService,
                options: .init()
            )
            .execute()
        }

        XCTAssertEqual(mockService.calls, [.request(path: "/v1/preReleaseVersions")])
        XCTAssertEqual(error, .versionNotFound)
    }

    func test_multiplePreReleaseVersions() async throws {
        mockService.requestReturnValue = PreReleaseVersionsResponse.fake(data: [.fake(), .fake()])

        let error: ReadPreReleaseVersionOperation.Error? = try await catchError {
            _ = try await ReadPreReleaseVersionOperation(
                service: mockService,
                options: .init()
            )
            .execute()
        }

        XCTAssertEqual(mockService.calls, [.request(path: "/v1/preReleaseVersions")])
        XCTAssertEqual(error, .multipleVersionsFound)
    }
}
