// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import ArgumentParser

extension BetaInviteType: CustomStringConvertible, ExpressibleByArgument {
    public typealias AllCases = [BetaInviteType]
    public static var allCases: AllCases {
        [.email, .publicLink]
    }

    public init?(argument: String) {
        self.init(rawValue: argument.uppercased())
    }

    public var description: String {
        rawValue.lowercased()
    }
}
