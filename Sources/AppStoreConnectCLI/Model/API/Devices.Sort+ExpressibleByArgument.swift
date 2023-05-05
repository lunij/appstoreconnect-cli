// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import ArgumentParser
import Foundation

extension Devices.Sort: Codable, ExpressibleByArgument, CustomStringConvertible {
    public var description: String {
        rawValue
    }
}
