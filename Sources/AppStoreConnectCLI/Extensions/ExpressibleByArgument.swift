// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

extension ExpressibleByArgument {
    static var allValueStringsFormatted: String {
        allValueStrings.formatted(.list(type: .or))
    }
}
