// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import ArgumentParser
import Foundation

extension ProfileState: CaseIterable, ExpressibleByArgument, CustomStringConvertible {
    public typealias AllCases = [ProfileState]
    public static var allCases: AllCases {
        [.active, .invalid]
    }

    public init?(argument: String) {
        self.init(rawValue: argument.uppercased())
    }

    public var description: String {
        rawValue.lowercased()
    }
}
