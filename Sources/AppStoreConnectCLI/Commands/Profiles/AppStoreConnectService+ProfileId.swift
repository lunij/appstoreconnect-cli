// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine
import Foundation

extension AppStoreConnectService {
    enum ProfileError: Error, LocalizedError {
        case notFound(String)
        case notUnique(String)

        var failureReason: String? {
            switch self {
            case let .notFound(identifier):
                return "Profile with UUID '\(identifier)' not found."
            case let .notUnique(identifier):
                return "'\(identifier)' does not uniquly identify a Profile."
            }
        }
    }

    /// Find the opaque internal resource identifier for a Device  matching `udid`. Use this for reading, modifying and deleting Device resources.
    ///
    /// - parameter udid: The device UUID string.
    /// - returns: The App Store Connect API resource identifier for the Profile UUID.
    func profileResourceId(matching uuid: String) -> AnyPublisher<String, Error> {
        #warning("limited by a single page")
        return request(APIEndpoint.listProfiles())
            .map {
                $0.data.filter { $0.attributes?.uuid == uuid }
            }
            .tryMap { profiles -> String in
                if profiles.count > 1 {
                    throw ProfileError.notUnique(uuid)
                }
                guard let profile = profiles.first else {
                    throw ProfileError.notFound(uuid)
                }
                return profile.id
            }
            .eraseToAnyPublisher()
    }
}
