// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import XCTest
@testable import AppStoreConnectCLI

final class ListBetaGroupsOperationTests: BaseTestCase {
    func test_listBetaGroups_success() async throws {
        mockService.requestAllPagesResponses = [
            BetaGroupsResponse.fake(data: [.fake()], included: [.app(.fake(id: "fakeAppId"))])
        ]

        let output = try await ListBetaGroupsOperation(service: mockService, options: .init()).execute()

        XCTAssertEqual(output.count, 1)
        XCTAssertEqual(output.first?.betaGroup.id, "fakeId")

        guard case let .app(app) = output.first?.includes.first else {
            return XCTFail("An app object is expected to be included")
        }
        XCTAssertEqual(app.id, "fakeAppId")
    }

    func test_listBetaGroups_propagatesUpstreamErrors() async throws {
        mockService.requestAllPagesError = FakeError()

        let error: FakeError? = try await catchError {
            _ = try await ListBetaGroupsOperation(service: mockService, options: .init()).execute()
        }

        XCTAssertNotNil(error)
    }
}
