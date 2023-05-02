// Copyright 2023 Itty Bitty Apps Pty Ltd

@testable import AppStoreConnectKit
import Bagbutik
import XCTest

final class UpdateProfileUseCaseTests: XCTestCase {
    func test_updateProfile_success() async throws {
        let service = BagbutikServiceMock { _, _ in
            (try Fixture(named: "v1/betagroups/betagroup_response").data, HTTPURLResponse.fake())
        }

        let profile = try await UpdateProfileUseCase(service: service).updateProfile(
            named: "fakeName",
            udidsToAdd: [],
            udidsToRemove: []
        )
    }
}
