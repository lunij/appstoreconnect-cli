// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik

extension BundleIdPlatform: ExpressibleByArgument {
    public static var allValueStrings: [String] {
        allCases.map { $0.rawValue.lowercased() }
    }

    public init?(argument: String) {
        self.init(rawValue: argument.uppercased())
    }
}
