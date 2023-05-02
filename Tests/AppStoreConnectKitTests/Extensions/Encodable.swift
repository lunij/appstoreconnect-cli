// Copyright 2023 Itty Bitty Apps Pty Ltd

import Foundation

extension Encodable {
    func encode() throws -> Data {
        try JSONEncoder().encode(self)
    }
}
