// Copyright 2023 Itty Bitty Apps Pty Ltd

import Foundation

typealias APIKeyID = String

extension APIKeyID {
    enum APIKeyError: Swift.Error, CustomStringConvertible, Equatable {
        case firstLineMissing
        case lastLineMissing
        case linesMissing
        case notFound

        var description: String {
            switch self {
            case .firstLineMissing:
                return """
                API Key has invalid format

                The key is required to start with \(String.firstLine) in the first line.
                """
            case .lastLineMissing:
                return """
                API Key has invalid format

                The key is required to end with \(String.lastLine) in the last line.
                """
            case .linesMissing:
                return """
                API Key has invalid format

                The key is required to consist of multiple lines, the starting line, the end line and several in-between.
                """
            case .notFound:
                return """
                API Key not found

                It can be provided either by using the environment variable \(Environment.appStoreConnectApiKey.rawValue)
                or by putting it as a file in the following directories: \(APIKeyID.searchPaths.joined(separator: ", "))
                """
            }
        }
    }

    static let searchPaths = ["./private_keys", "~/private_keys", "~/.private_keys", "~/.appstoreconnect/private_keys"]

    func loadKey() throws -> String {
        let apiKey = try (Environment.appStoreConnectApiKey.load() ?? findKeyFileURL().map { try String(contentsOf: $0, encoding: .utf8) })

        guard let apiKey = apiKey, apiKey.isNotEmpty else {
            throw APIKeyError.notFound
        }

        let lines = apiKey.components(separatedBy: .newlines)

        guard lines.first == .firstLine else {
            throw APIKeyError.firstLineMissing
        }

        guard lines.last == .lastLine else {
            throw APIKeyError.lastLineMissing
        }

        guard lines.count > 3 else {
            throw APIKeyError.linesMissing
        }

        return apiKey
    }

    private func findKeyFileURL() -> URL? {
        let fileManager = FileManager()
        let homeDirectoryPath = fileManager.homeDirectoryForCurrentUser.path
        let authKeyFilename = "AuthKey_\(self).p8"

        let fullyQualifiedURLs = Self.searchPaths.lazy.map { path -> URL in
            let expandedPath = path.replacingOccurrences(of: "~", with: homeDirectoryPath)
            return URL(fileURLWithPath: expandedPath).appendingPathComponent(authKeyFilename)
        }

        return fullyQualifiedURLs.first { fileManager.fileExists(atPath: $0.path) }
    }
}

private extension String {
    static let firstLine = "-----BEGIN PRIVATE KEY-----"
    static let lastLine = "-----END PRIVATE KEY-----"
}
