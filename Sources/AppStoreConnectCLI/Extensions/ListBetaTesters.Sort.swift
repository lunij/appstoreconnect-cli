// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import ArgumentParser

extension ListBetaTesters.Sort: CustomStringConvertible, ExpressibleByArgument {
    public var description: String {
        rawValue
    }
}
