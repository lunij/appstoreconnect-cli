// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik

extension CertificateType: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(rawValue: argument.uppercased())
    }
}
