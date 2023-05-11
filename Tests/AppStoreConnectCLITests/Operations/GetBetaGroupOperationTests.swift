// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Foundation
import XCTest
@testable import AppStoreConnectCLI

final class GetBetaGroupOperationTests: BaseTestCase {
    func test_betaGroup_success() async throws {
        mockService.requestReturnValue = BetaGroupsResponse.fake(data: [.fake(attributes: .init(name: "Fake Group"))])

        let betaGroup = try await GetBetaGroupOperation(service: mockService, options: .fake(betaGroupName: "Fake Group")).execute()

        XCTAssertEqual(betaGroup.attributes?.name, "Fake Group")
    }

    func test_betaGroup_notFound() async throws {
        mockService.requestReturnValue = BetaGroupsResponse.fake(data: [])

        let error: GetBetaGroupOperation.Error? = try await catchError {
            _ = try await GetBetaGroupOperation(service: mockService, options: .fake(betaGroupName: "non-existend name")).execute()
        }

        XCTAssertEqual(error, .betaGroupNotFound(groupName: "non-existend name", bundleId: "com.example.test", appId: "1234567890"))
        XCTAssertEqual(error?.description, "Beta group not found with the name 'non-existend name', the bundle id 'com.example.test' and the app id '1234567890'")
    }
}

private extension GetBetaGroupOperation.Options {
    static func fake(betaGroupName: String = "fakeBetaGroupName") -> Self {
        .init(
            appId: "1234567890",
            bundleId: "com.example.test",
            betaGroupName: betaGroupName
        )
    }
}
