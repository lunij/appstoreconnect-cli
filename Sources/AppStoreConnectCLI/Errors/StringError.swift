// Copyright 2023 Itty Bitty Apps Pty Ltd

import Foundation

enum StringError: Error, CustomStringConvertible, Equatable {
    case encodingToUTF8Failed

    var description: String {
        switch self {
        case .encodingToUTF8Failed:
            return "String encoding to UTF8 failed"
        }
    }
}
