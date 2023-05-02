// Copyright 2023 Itty Bitty Apps Pty Ltd

import Files
import Foundation

extension Folder {
    static let tests: Folder = try! Folder(
        path: URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Fixtures.bundle")
            .path
    )
}
