// Copyright 2023 Itty Bitty Apps Pty Ltd

@testable import AppStoreConnectKit
import Bagbutik
import XCTest

final class UpdateBetaGroupOperationTests: XCTestCase {
    func test_updateBetaGroup_success() async throws {
        let service = BagbutikServiceMock { _, _ in
            let response = BetaGroupResponse(data: .fake(), links: .fake())
            return (try response.encode(), HTTPURLResponse.fake())
        }

        let betaGroup = try await UpdateBetaGroupOperation(service: service, options: .fake()).execute()

        XCTAssertEqual(betaGroup.id, "fakeId")
    }
}

private extension UpdateBetaGroupOperation.Options {
    static func fake(
        betaGroup: BetaGroup = .fake(),
        betaGroupName: String? = nil,
        publicLinkEnabled: Bool? = nil,
        publicLinkLimit: Int? = nil,
        publicLinkLimitEnabled: Bool? = nil
    ) -> Self {
        .init(
            betaGroup: betaGroup,
            betaGroupName: betaGroupName,
            publicLinkEnabled: publicLinkEnabled,
            publicLinkLimit: publicLinkLimit,
            publicLinkLimitEnabled: publicLinkLimitEnabled
        )
    }
}
