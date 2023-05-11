// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Core
import Bagbutik_Models

extension UsersResponse {
    static func fake(
        data: [User],
        included: [App]? = nil,
        links: PagedDocumentLinks = .fake()
    ) -> Self {
        .init(data: data, included: included, links: links)
    }
}
