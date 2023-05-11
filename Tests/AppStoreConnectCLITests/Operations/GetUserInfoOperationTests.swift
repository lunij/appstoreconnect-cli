// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import XCTest
@testable import AppStoreConnectCLI

final class GetUserInfoOperationTests: BaseTestCase {
    func test_getUser_userNotFound() async throws {
        mockService.requestReturnValue = UsersResponse.fake(data: [])

        let error: GetUserInfoOperation.Error? = try await catchError {
            _ = try await GetUserInfoOperation(service: mockService, options: .fake()).execute()
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
