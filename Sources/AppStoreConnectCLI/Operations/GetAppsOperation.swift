// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models

struct GetAppsOperation: APIOperation {
    struct Options {
        let bundleIds: [String]
    }

    enum Error: Swift.Error, CustomStringConvertible {
        case couldntFindAnyAppsMatching(bundleIds: [String])
        case appsDoNotExist(bundleIds: [String])

        var description: String {
            switch self {
            case let .couldntFindAnyAppsMatching(bundleIds):
                return "No apps were found matching \(bundleIds)."
            case let .appsDoNotExist(bundleIds):
                return "Specified apps were non found / do not exist: \(bundleIds)."
            }
        }
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> [Bagbutik_Models.App] {
        let bundleIds = options.bundleIds
        let apps = try await service
            .request(.listAppsV1(filters: [.bundleId(bundleIds)]))
            .data

        guard !apps.isEmpty else {
            throw Error.couldntFindAnyAppsMatching(bundleIds: bundleIds)
        }

        let responseBundleIds = Set(apps.compactMap { $0.attributes?.bundleId })
        let bundleIdsSet = Set(bundleIds)

        guard responseBundleIds == bundleIdsSet else {
            let nonExistentBundleIds = bundleIdsSet.subtracting(responseBundleIds)
            throw Error.appsDoNotExist(bundleIds: Array(nonExistentBundleIds))
        }

        return apps
    }
}
