// Copyright 2023 Itty Bitty Apps Pty Ltd

import XCTest
@testable import AppStoreConnectCLI

final class GetUserInfoOperationTests: XCTestCase {
    func test_getUser_userNotFound() async throws {
        let service = BagbutikServiceMock { _, _ in
            (try Fixture(named: "v1/users/no_user").data, HTTPURLResponse.fake())
        }

        let error: GetUserInfoOperation.Error? = try await catchError {
            _ = try await GetUserInfoOperation(service: service, options: .fake()).execute()
        }

        XCTAssertEqual(error, .userNotFound(email: "fakeEmail"))
    }
}

private extension GetUserInfoOperation.Options {
    static func fake(
        email: String = "fakeEmail",
        includeVisibleApps: Bool = false
    ) -> Self {
        .init(email: email, includeVisibleApps: includeVisibleApps)
    }
}
