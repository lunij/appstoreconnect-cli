// Copyright 2023 Itty Bitty Apps Pty Ltd

@testable import AppStoreConnectKit
import Bagbutik
import XCTest

final class ListBetaGroupsOperationTests: XCTestCase {
    func test_listBetaGroups_success() async throws {
        let service = BagbutikServiceMock { _, _ in
            (try Fixture(named: "v1/betagroups/list_betagroup").data, HTTPURLResponse.fake())
        }

        let output = try await ListBetaGroupsOperation(service: service, options: .init()).execute()

        XCTAssertEqual(output.count, 1)
        XCTAssertEqual(output.first?.betaGroup.id, "12345678-90ab-cdef-1234-567890abcdef")

        guard case let .app(app) = output.first?.includes.first else {
            return XCTFail("An app object is expected to be included")
        }
        XCTAssertEqual(app.id, "1234567890")
    }

    func test_listBetaGroups_propagatesUpstreamErrors() async throws {
        let service = BagbutikServiceMock { _, _ in
            throw FakeError()
        }

        let error: FakeError? = try await catchError {
            _ = try await ListBetaGroupsOperation(service: service, options: .init()).execute()
        }

        XCTAssertNotNil(error)
    }
}
