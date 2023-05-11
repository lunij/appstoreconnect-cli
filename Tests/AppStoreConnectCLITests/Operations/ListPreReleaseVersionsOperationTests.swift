// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import XCTest
@testable import AppStoreConnectCLI

final class ListPreReleaseVersionsOperationTests: BaseTestCase {
    func test_listsPreReleaseVersions() async throws {
        mockService.requestAllPagesResponses = [PreReleaseVersionsResponse.fake(data: [.fake(attributes: .init(version: "1.1"))])]

        let responses = try await ListPreReleaseVersionsOperation(service: mockService, options: .init())
            .execute()

        let preReleaseVersion = try XCTUnwrap(responses.first?.data.first)
        XCTAssertEqual(preReleaseVersion.id, "fakeId")
        XCTAssertEqual(preReleaseVersion.attributes?.version, "1.1")
    }
}
