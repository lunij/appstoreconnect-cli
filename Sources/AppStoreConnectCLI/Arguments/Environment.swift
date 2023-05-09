// Copyright 2023 Itty Bitty Apps Pty Ltd

import Foundation

enum Environment: String {
    case appStoreConnectApiKey = "APP_STORE_CONNECT_API_KEY"
    case appStoreConnectApiKeyId = "APP_STORE_CONNECT_API_KEY_ID"
    case appStoreConnectIssuerId = "APP_STORE_CONNECT_ISSUER_ID"

    func load() -> String {
        load() ?? ""
    }

    func load() -> String? {
        ProcessInfo.processInfo.environment[rawValue]
    }
}
