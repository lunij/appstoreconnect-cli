// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import ArgumentParser
import Foundation

extension DeviceStatus: CaseIterable, ExpressibleByArgument, CustomStringConvertible {
    public typealias AllCases = [DeviceStatus]

    public static var allCases: AllCases {
        [.enabled, .disabled]
    }

    public init?(argument: String) {
        self.init(rawValue: argument.uppercased())
    }

    public var description: String {
        rawValue.lowercased()
    }
}
