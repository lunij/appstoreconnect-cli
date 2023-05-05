// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import ArgumentParser
import Foundation

extension Platform: ExpressibleByArgument, CustomStringConvertible {
    public typealias AllCases = [Platform]

    public static var allCases: AllCases {
        [ios, macOs, tvOs, watchOs]
    }

    public init?(argument: String) {
        self.init(rawValue: argument.uppercased())
    }

    public var description: String {
        rawValue.lowercased()
    }
}
