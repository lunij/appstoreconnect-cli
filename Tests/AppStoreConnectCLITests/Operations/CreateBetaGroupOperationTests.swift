// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import XCTest
@testable import AppStoreConnectCLI

final class CreateBetaGroupOperationTests: XCTestCase {
    func test_createBetaGroup_success() async throws {
        let expectedApp = App.fake()

        let service = BagbutikServiceMock { _, _ in
            (try Fixture(named: "v1/betagroups/betagroup_response").data, HTTPURLResponse.fake())
        }
        let betaGroup = try await CreateBetaGroupOperation(service: service, options: .fake(app: expectedApp))
            .execute()

        XCTAssertEqual(betaGroup.app?.id, expectedApp.id)
        XCTAssertEqual(betaGroup.id, "12345678-90ab-cdef-1234-567890abcdef")
    }

    func test_createBetaGroup_propagatesUpstreamErrors() async throws {
        let service = BagbutikServiceMock { _, _ in
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
