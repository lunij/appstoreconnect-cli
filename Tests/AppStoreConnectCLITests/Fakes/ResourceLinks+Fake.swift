// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Core
import Foundation

extension ResourceLinks {
    static func fake(self: String = URL.fakeWebURL.absoluteString) -> Self {
        .init(self: self)
    }
}
