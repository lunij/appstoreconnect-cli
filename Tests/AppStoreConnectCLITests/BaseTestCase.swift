// Copyright 2023 Itty Bitty Apps Pty Ltd

import XCTest

class BaseTestCase: XCTestCase {
    var mockService: BagbutikServiceMock!

    override func setUp() {
        super.setUp()
        mockService = .init()
    }
}
