// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

extension BetaGroup {
    static func fake(
        id: String = "fakeId",
        links: ResourceLinks = .fake(),
        attributes: Attributes? = nil,
        relationships: Relationships? = nil
    ) -> Self {
        .init(
            id: id,
            links: links,
            attributes: attributes,
            relationships: relationships
        )
    }
}
