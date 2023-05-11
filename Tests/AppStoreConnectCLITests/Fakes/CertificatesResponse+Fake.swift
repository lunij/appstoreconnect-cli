// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Core
@testable import AppStoreConnectCLI

extension CertificatesResponse {
    static func fake(
        data: [LossyCertificate],
        links: PagedDocumentLinks = .fake()
    ) -> Self {
        .init(data: data, links: links)
    }
}
