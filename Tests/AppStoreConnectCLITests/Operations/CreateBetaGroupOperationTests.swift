// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import XCTest
@testable import AppStoreConnectCLI

final class CreateBetaGroupOperationTests: BaseTestCase {
    func test_createBetaGroup_success() async throws {
        let expectedApp = App.fake()
        mockService.requestReturnValue = BetaGroupResponse.fake(data: .fake())

        let betaGroup = try await CreateBetaGroupOperation(service: mockService, options: .fake(app: expectedApp))
            .execute()

        XCTAssertEqual(mockService.calls, [.request(path: "/v1/betaGroups")])
        XCTAssertEqual(betaGroup.app?.id, expectedApp.id)
        XCTAssertEqual(betaGroup.id, "fakeId")
    }

    func test_createBetaGroup_propagatesUpstreamErrors() async throws {
        let service = BagbutikServiceOverrideMock { _, _ in
            throw FakeError()
        }

        let error: FakeError? = try await catchError {
            _ = try await CreateBetaGroupOperation(service: service, options: .fake()).execute()
        }

        XCTAssertNotNil(error)
    }
}

private extension CreateBetaGroupOperation.Options {
    static func fake(
        app: Bagbutik_Models.App = .fake(),
        groupName: String = "fakeGroupName",
        publicLinkEnabled: Bool = false,
        publicLinkLimit: Int? = nil
    ) -> Self {
        .init(
            app: app,
            groupName: groupName,
            publicLinkEnabled: publicLinkEnabled,
            publicLinkLimit: publicLinkLimit
        )
    }
}
