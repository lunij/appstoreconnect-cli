// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import ArgumentParser
import Foundation

extension ProfileType: CaseIterable, ExpressibleByArgument, CustomStringConvertible {
    public typealias AllCases = [ProfileType]
    public static var allCases: AllCases {
        [
            .iOSAppDevelopment,
            .iOSAppStore,
            .iOSAppAdHoc,
            .iOSAppInHouse,
            .macAppDevelopment,
            .macAppStore,
            .macAppDirect,
            .tvOSAppDevelopment,
            .tvOSAppStore,
            .tvOSAppAdHoc,
            .tvOSAppInHouse
        ]
    }

    public init?(argument: String) {
        self.init(rawValue: argument.uppercased())
    }

    public var description: String {
        rawValue.lowercased()
    }
}
