// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

extension JWT {
    init(_ authOptions: AuthOptions) throws {

        guard authOptions.apiIssuer.value.isNotEmpty else {
            throw AuthOptions.Error.apiIssuerIdNotProvided
        }

        guard authOptions.apiKeyId.value.isNotEmpty else {
            throw AuthOptions.Error.apiKeyIdNotProvided
        }

        try self.init(
            keyId: authOptions.apiKeyId.value,
            issuerId: authOptions.apiIssuer.value,
            privateKey: try authOptions.apiKeyId.loadPEM()
        )
    }
}
