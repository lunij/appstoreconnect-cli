// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Core

extension JWT {
    static func fake() throws -> Self {
        try JWT(keyId: .keyId, issuerId: .issuerId, privateKey: .privateKey)
    }
}

private extension String {
    static let keyId = "P9M252746H"
    static let issuerId = "82067982-6b3b-4a48-be4f-5b10b373c5f2"
    static let privateKey = """
    -----BEGIN PRIVATE KEY-----
    MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgevZzL1gdAFr88hb2
    OF/2NxApJCzGCEDdfSp6VQO30hyhRANCAAQRWz+jn65BtOMvdyHKcvjBeBSDZH2r
    1RTwjmYSi9R/zpBnuQ4EiMnCqfMPWiZqB4QdbAd0E7oH50VpuZ1P087G
    -----END PRIVATE KEY-----
    """
}
