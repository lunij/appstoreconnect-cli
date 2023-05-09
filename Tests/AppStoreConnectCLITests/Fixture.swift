// Copyright 2023 Itty Bitty Apps Pty Ltd

import Files
import Foundation
import XCTest

struct Fixture {
    let data: Data

    init(named filename: String, in folder: Folder = .tests) throws {
        let file = try folder.file(named: "\(filename).json")
        data = try file.read()
    }
}
