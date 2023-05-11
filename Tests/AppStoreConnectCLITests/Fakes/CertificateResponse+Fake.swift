// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Core
import Bagbutik_Models

extension CertificateResponse {
    static func fake(
        data: Certificate,
        links: DocumentLinks = .fake()
    ) -> Self {
        .init(data: data, links: links)
    }
}
