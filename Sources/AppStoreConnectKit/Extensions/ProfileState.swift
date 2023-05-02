// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik

typealias ProfileState = Profile.Attributes.ProfileState

extension ProfileState: ExpressibleByArgument {
    public static var allValueStrings: [String] {
        allCases.map { $0.rawValue.lowercased() }
    }

    public init?(argument: String) {
        self.init(rawValue: argument.uppercased())
    }
}
