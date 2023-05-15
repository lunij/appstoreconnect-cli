// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Foundation
import Yams

extension APIConfiguration {
    init(_ authOptions: AuthOptions) throws {
        guard authOptions.apiIssuer.isEmpty == false else {
            throw AuthOptions.Error.issuerIdNotProvided
        }

        guard authOptions.apiKeyId.isEmpty == false else {
            throw AuthOptions.Error.apiKeyIdNotProvided
        }

        self.init(
            issuerID: authOptions.apiIssuer,
            privateKeyID: authOptions.apiKeyId,
            privateKey: try authOptions.apiKeyId.loadKey().extractPrivateKeyValue()
        )
    }
}

private extension String {
    func extractPrivateKeyValue() -> String {
        components(separatedBy: .newlines)
            .filter { !$0.hasSuffix("PRIVATE KEY-----") }
            .joined()
    }
}
