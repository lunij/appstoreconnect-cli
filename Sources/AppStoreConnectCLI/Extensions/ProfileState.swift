// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

typealias ProfileState = Bagbutik_Models.Profile.Attributes.ProfileState

extension ProfileState: ExpressibleByArgument {
    public static var allValueStrings: [String] {
        allCases.map { $0.rawValue.lowercased() }
    }

    public init?(argument: String) {
        self.init(rawValue: argument.uppercased())
    }
}
