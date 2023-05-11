// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Core
import Bagbutik_Models
@testable import AppStoreConnectCLI

extension PreReleaseVersionsResponse {
    static func fake(
        data: [PrereleaseVersion],
        included: [PreReleaseVersionsResponse.Included]? = nil,
        links: PagedDocumentLinks = .fake()
    ) -> Self {
        .init(data: data, included: included, links: links)
    }
}
