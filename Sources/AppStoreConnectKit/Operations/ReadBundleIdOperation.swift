// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct ReadBundleIdOperation: APIOperation {
    
    struct Options {
        let bundleId: String
    }

    enum Error: Swift.Error, CustomStringConvertible, Equatable {
        case bundleIdNotFound(String)
        case bundleIdNotUnique(String)

        var description: String {
            switch self {
            case let .bundleIdNotFound(bundleId):
                return "Bundle ID not found: \(bundleId)"
            case let .bundleIdNotUnique(bundleId):
                return "Bundle ID is not unique: \(bundleId)"
            }
        }
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> BundleId {
        let bundleIds = try await service.request(
            .listBundleIdsV1(filters: [.identifier([options.bundleId])])
        )
        .data
        .filter { $0.attributes?.identifier == options.bundleId }

        if bundleIds.count > 1 {
            throw Error.bundleIdNotUnique(options.bundleId)
        }

        guard let bundleId = bundleIds.first else {
            throw Error.bundleIdNotFound(options.bundleId)
        }

        return bundleId
    }
}
