// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Bagbutik_Provisioning

struct ListBundleIdsOperation: APIOperation {
    struct Options {
        let identifiers: [String]
        let names: [String]
        let platforms: [BundleIdPlatform]
        let seedIds: [String]
        let limit: Int?
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> [Bagbutik_Models.BundleId] {
        var filters: [ListBundleIdsV1.Filter] = []

        if options.identifiers.isNotEmpty { filters.append(.identifier(options.identifiers)) }
        if options.names.isNotEmpty { filters.append(.name(options.names)) }
        if options.platforms.isNotEmpty { filters.append(.platform(options.platforms)) }
        if options.seedIds.isNotEmpty { filters.append(.seedId(options.seedIds)) }

        guard let limit = options.limit else {
            return try await service.requestAllPages(.listBundleIdsV1(filters: filters)).data
        }

        return try await service.request(.listBundleIdsV1(filters: filters, limits: [.limit(limit)])).data
    }
}
