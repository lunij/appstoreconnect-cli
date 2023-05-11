// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import XCTest
@testable import AppStoreConnectCLI

final class UpdateProfileUseCaseTests: XCTestCase {
    var mockService: BagbutikServiceMock!

    override func setUp() {
        super.setUp()
        mockService = .init()
    }

    #warning("to be implemented")
//    func test_updateProfile_success() async throws {
//        mockService

//        try await UpdateProfileUseCase(service: mockService).updateProfile(
//            id: "fakeId",
//            udidsToAdd: [],
//            udidsToRemove: [],
//            outputOptions: .init()
//        )
//    }
}
