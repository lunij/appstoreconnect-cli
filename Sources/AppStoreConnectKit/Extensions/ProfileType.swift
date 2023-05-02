// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik

typealias ProfileType = Profile.Attributes.ProfileType

extension ProfileType {
    var isDistributionProfile: Bool {
        [.iOSAppStore, .macAppStore, .macCatalystAppStore, .tvOSAppStore].contains(self)
    }
}

extension ProfileType: ExpressibleByArgument {
    public static var allValueStrings: [String] {
        allCases.map { $0.rawValue.lowercased() }
    }

    public init?(argument: String) {
        self.init(rawValue: argument.uppercased())
    }
}
