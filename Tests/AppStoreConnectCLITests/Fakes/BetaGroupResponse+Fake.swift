// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Core
import Bagbutik_Models

extension BetaGroupResponse {
    static func fake(
        data: BetaGroup,
        included: [Included]? = nil,
        links: DocumentLinks = .fake()
    ) -> Self {
        .init(data: data, included: included, links: links)
    }
}
