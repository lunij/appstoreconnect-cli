// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Core

extension JWT {
    init(_ authOptions: AuthOptions) throws {
        guard authOptions.apiIssuer.isNotEmpty else {
            throw AuthOptions.Error.issuerIdNotProvided
        }

        guard authOptions.apiKeyId.isNotEmpty else {
            throw AuthOptions.Error.apiKeyIdNotProvided
        }

        try self.init(
            keyId: authOptions.apiKeyId,
            issuerId: authOptions.apiIssuer,
            privateKey: try authOptions.apiKeyId.loadKey()
        )
    }
}
