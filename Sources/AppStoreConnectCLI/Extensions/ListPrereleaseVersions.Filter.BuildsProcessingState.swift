// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import ArgumentParser
import Foundation

extension ListPrereleaseVersions.Filter.BuildsProcessingState: Codable, ExpressibleByArgument, CustomStringConvertible {
    public init?(argument: String) {
        self.init(rawValue: argument.uppercased())
    }

    public var description: String {
        rawValue.lowercased()
    }
}
