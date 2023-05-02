// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct GetAppsOperation: APIOperation {

    struct Options {
        let bundleIds: [String]
    }

    enum GetAppIdsError: Swift.Error, CustomStringConvertible {
        case couldntFindAnyAppsMatching(bundleIds: [String])
        case appsDoNotExist(bundleIds: [String])

        var description: String {
            switch self {
            case .couldntFindAnyAppsMatching(let bundleIds):
                return "No apps were found matching \(bundleIds)."
            case .appsDoNotExist(let bundleIds):
                return "Specified apps were non found / do not exist: \(bundleIds)."
            }
        }
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> [App] {
        let bundleIds = options.bundleIds
        let apps = try await service
            .request(.listAppsV1(filters: [.bundleId(bundleIds)]))
            .data

        guard !apps.isEmpty else {
            throw GetAppIdsError.couldntFindAnyAppsMatching(bundleIds: bundleIds)
        }

        let responseBundleIds = Set(apps.compactMap { $0.attributes?.bundleId })
        let bundleIdsSet = Set(bundleIds)

        guard responseBundleIds == bundleIdsSet else {
            let nonExistentBundleIds = bundleIdsSet.subtracting(responseBundleIds)
            throw GetAppIdsError.appsDoNotExist(bundleIds: Array(nonExistentBundleIds))
        }

        return apps
    }
}
