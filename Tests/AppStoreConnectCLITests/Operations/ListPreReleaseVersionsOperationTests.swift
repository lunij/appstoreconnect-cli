// Copyright 2023 Itty Bitty Apps Pty Ltd

import XCTest
@testable import AppStoreConnectCLI

final class ListPreReleaseVersionsOperationTests: XCTestCase {
    func test_listsPreReleaseVersions() async throws {
        let service = BagbutikServiceMock { _, _ in
            (try Fixture(named: "v1/prerelease_version/list_prerelease_version").data, HTTPURLResponse.fake())
        }

        let output = try await ListPreReleaseVersionsOperation(service: service, options: .init())
            .execute()

        let preReleaseVersion = try XCTUnwrap(output.first?.preReleaseVersion)
        XCTAssertEqual(preReleaseVersion.id, "a06f32e3-9101-47fc-b439-db334678a952")
        XCTAssertEqual(preReleaseVersion.attributes?.platform, .iOS)
        XCTAssertEqual(preReleaseVersion.attributes?.version, "1.1")

        let includes = try XCTUnwrap(output.first?.includes)
        guard case let .app(app) = includes.first else {
            return XCTFail("First included is expected to be an app")
        }
        XCTAssertEqual(app.id, "1511865740")
        XCTAssertEqual(app.attributes?.name, "Test App 3")
        XCTAssertEqual(app.attributes?.bundleId, "iba.test3")
    }
}
