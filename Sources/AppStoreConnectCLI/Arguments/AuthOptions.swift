// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Foundation

struct AuthOptions: ParsableArguments {
    enum Error: Swift.Error, CustomStringConvertible, Equatable {
        case issuerIdNotProvided
        case apiKeyIdNotProvided

        var description: String {
            switch self {
            case .issuerIdNotProvided:
                return "App Store Connect API Issuer ID not provided. "
                    + "Either add it as option on command line or use the environment variable \(Environment.appStoreConnectIssuerId.rawValue)."
            case .apiKeyIdNotProvided:
                return "App Store Connect API Key ID not provided. "
                    + "Either add it as option on command line or use the environment variable \(Environment.appStoreConnectApiKeyId.rawValue)."
            }
        }
    }

    @Option(
        help: ArgumentHelp(
            "An AppStore Connect API Key issuer ID.",
            discussion:
            """
            The value for this option can be obtained from the App Store Connect and takes the form of a UUID.

            If not specified on the command line this value will be read from the environment variable \(Environment.appStoreConnectIssuerId.rawValue).
            """,
            valueName: "uuid"
        )
    )
    var apiIssuer: String = Environment.appStoreConnectIssuerId.load()

    @Option(
        help: ArgumentHelp(
            "An AppStoreConnect API Key ID.",
            discussion:
            """
            The value for this option can be obtained from the App Store Connect and takes the form of an 10 character alpha-numeric identifier, eg. 7MM5YSX5LS

            If not specified on the command line the value of this option will be read from the environment variable \(Environment.appStoreConnectApiKeyId.rawValue).

            The environment will be searched for key with the name of \(Environment.appStoreConnectApiKey.rawValue). The contents of this environment key are expected to be a PKCS 8 (.p8) formatted private key associated with this Key ID.

            If the \(Environment.appStoreConnectApiKey.rawValue) environment variable is empty, in the incorrect format, or not found then the following directories will be searched in sequence for a private key file with the name of 'AuthKey_<keyid>.p8': \(ListFormatter.localizedString(byJoining: APIKeyID.searchPaths)).
            """,
            valueName: "keyid"
        )
    )
    var apiKeyId: APIKeyID = Environment.appStoreConnectApiKeyId.load()
}
