// Copyright 2023 Itty Bitty Apps Pty Ltd

import XCTest

extension XCTestCase {
    func catchError<E: Error>(_ closure: () async throws -> Void) async throws -> E? {
        var catchedError: E?
        do {
            try await closure()
        } catch let error as E {
            catchedError = error
        }
        return catchedError
    }
}
