// Copyright 2023 Itty Bitty Apps Pty Ltd

import Foundation

extension Data {
    func stringUTF8Encoded() throws -> String {
        guard let string = String(data: self, encoding: .utf8) else {
            throw StringError.encodingToUTF8Failed
        }
        return string
    }
}
