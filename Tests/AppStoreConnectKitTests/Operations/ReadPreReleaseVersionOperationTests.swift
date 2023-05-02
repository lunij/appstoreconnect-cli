// Copyright 2023 Itty Bitty Apps Pty Ltd

@testable import AppStoreConnectKit
import XCTest

final class ReadPreReleaseVersionOperationTests: XCTestCase {
    func test_onePreReleaseVersion() async throws {
        let service = BagbutikServiceMock { _, _ in
            (try Fixture(named: "v1/prerelease_version/one_prerelease_version").data, HTTPURLResponse.fake())
        }

        let output = try await ReadPreReleaseVersionOperation(
            service: service,
            options: .init(filterAppId: "1504341572", filterVersion: "1.0")
        )
        .execute()

        XCTAssertEqual(output.preReleaseVersion.attributes?.version, "1.0")
    }

    func test_noPreReleaseVersion() async throws {
        let service = BagbutikServiceMock { _, _ in
            (try Fixture(named: "v1/prerelease_version/no_prerelease_version").data, HTTPURLResponse.fake())
        }

        let error: ReadPreReleaseVersionOperation.Error? = try await catchError {
            _ = try await ReadPreReleaseVersionOperation(
                service: service,
                options: .init(filterAppId: "1504341572", filterVersion: "0.0")
            )
            .execute()
        }

        XCTAssertEqual(error, .versionNotFound)
    }

    func test_multiplePreReleaseVersions() async throws {
        let service = BagbutikServiceMock { _, _ in
            (try Fixture(named: "v1/prerelease_version/not_unique").data, HTTPURLResponse.fake())
        }

        let error: ReadPreReleaseVersionOperation.Error? = try await catchError {
            _ = try await ReadPreReleaseVersionOperation(
                service: service,
                options: .init(filterAppId: "1504341572", filterVersion: "1.0")
            )
            .execute()
        }

        XCTAssertEqual(error, .multipleVersionsFound)
    }
}
