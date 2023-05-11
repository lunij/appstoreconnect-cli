// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine
import Foundation

struct ReadPreReleaseVersionOperation: APIOperation {
    struct Options {
        let filterAppId: String
        let filterVersion: String
    }

    enum Error: LocalizedError {
        case noVersionExists
        case versionNotUnique

        var errorDescription: String? {
            switch self {
            case .noVersionExists:
                return "No prerelease version exists"
            case .versionNotUnique:
                return "More than 1 prerelease version returned"
            }
        }
    }

    typealias PreReleaseVersion = AppStoreConnect_Swift_SDK.PrereleaseVersion
    typealias Relationships = [AppStoreConnect_Swift_SDK.PreReleaseVersionRelationship]?
    typealias Output = (preReleaseVersion: PreReleaseVersion, relationships: Relationships)

    private let options: Options

    init(options: Options) {
        self.options = options
    }

    func execute(with requestor: EndpointRequestor) -> AnyPublisher<Output, Swift.Error> {
        var filters: [ListPrereleaseVersions.Filter] = []
        filters += options.filterAppId.isEmpty ? [] : [.app([options.filterAppId])]
        filters += options.filterVersion.isEmpty ? [] : [.version([options.filterVersion])]

        let endpoint = APIEndpoint.prereleaseVersions(
            filter: filters,
            include: [.app]
        )

        return requestor.request(endpoint)
            .tryMap { response throws -> Output in
                if response.data.count > 1 {
                    throw Error.versionNotUnique
                }

                guard let preReleaseVersion = response.data.first else {
                    throw Error.noVersionExists
                }

                return Output(preReleaseVersion: preReleaseVersion, relationships: response.included)
            }
            .eraseToAnyPublisher()
    }
}
