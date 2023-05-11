// Copyright 2023 Itty Bitty Apps Pty Ltd

import Foundation

extension Collection {
    func nilIfEmpty() -> Self? {
        isEmpty ? nil : self
    }

    var isNotEmpty: Bool { isEmpty == false }
}
