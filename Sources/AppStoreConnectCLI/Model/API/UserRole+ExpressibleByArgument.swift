// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import ArgumentParser
import Foundation

extension UserRole: ExpressibleByArgument, CustomStringConvertible {
    public typealias AllCases = [UserRole]

    public init?(argument: String) {
        self.init(rawValue: argument.uppercased())
    }

    public static var allCases: AllCases {
        [.accessToReports, .accountHolder, .admin, .appManager, .customerSupport, .developer, .finance, .marketing, .readOnly, .sales, .technical]
    }

    public var description: String {
        rawValue.lowercased()
    }
}
