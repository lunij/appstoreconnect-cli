// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Core
@testable import AppStoreConnectCLI

extension LossyCertificate {
    static func fake(
        id: String = "fakeId",
        links: ResourceLinks = .fake(),
        attributes: Attributes? = nil
    ) -> Self {
        .init(id: id, links: links, attributes: attributes)
    }
}
