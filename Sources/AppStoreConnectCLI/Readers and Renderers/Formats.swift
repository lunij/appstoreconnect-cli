// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import FileSystem
import Foundation

enum OutputFormat: String, CaseIterable, Codable, EnumerableFlag {
    case csv
    case json
    case table
    case yaml
}

extension OutputFormat: CustomStringConvertible {
    var description: String {
        rawValue
    }
}

extension OutputFormat: ExpressibleByArgument {
    init?(argument: String) {
        self.init(rawValue: argument.lowercased())
    }
}

extension InputFormat: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

extension InputFormat: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(rawValue: argument.lowercased())
    }
}
