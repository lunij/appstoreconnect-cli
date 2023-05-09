// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import XCTest
@testable import AppStoreConnectCLI

final class UpdateProfileUseCaseTests: XCTestCase {
    func test_updateProfile_success() async throws {
        let service = BagbutikServiceMock { _, _ in
            (try Fixture(named: "v1/betagroups/betagroup_response").data, HTTPURLResponse.fake())
        }

        try await UpdateProfileUseCase(service: service).updateProfile(
            id: "fakeId",
            udidsToAdd: [],
            udidsToRemove: [],
            outputOptions: .init()
        )
    }
}
