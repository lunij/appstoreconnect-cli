// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Bagbutik_TestFlight

struct ReadPreReleaseVersionOperation: APIOperation {
    struct Options {
        var filterAppId = ""
        var filterVersion = ""
    }

    enum Error: Swift.Error, CustomStringConvertible, Equatable {
        case versionNotFound
        case multipleVersionsFound

        var description: String {
            switch self {
            case .versionNotFound:
                return "No prerelease version exists"
            case .multipleVersionsFound:
                return "More than 1 prerelease version returned"
            }
        }
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> PreReleaseVersionsResponse {
        var filters: [ListPreReleaseVersionsV1.Filter] = []
        if options.filterAppId.isNotEmpty { filters += [.app([options.filterAppId])] }
        if options.filterVersion.isNotEmpty { filters += [.version([options.filterVersion])] }

        let response = try await service.request(.listPreReleaseVersionsV1(
            filters: filters,
            includes: [.app]
        ))

        if response.data.count > 1 {
            throw Error.multipleVersionsFound
        }

        guard let preReleaseVersion = response.data.first else {
            throw Error.versionNotFound
        }

        return response
    }
}
