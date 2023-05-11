// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Core
import Bagbutik_Models

extension Certificate {
    static func fake(
        id: String = "fakeId",
        links: ResourceLinks = .fake(),
        attributes: Attributes? = nil
    ) -> Self {
        .init(id: id, links: links, attributes: attributes)
    }
}
