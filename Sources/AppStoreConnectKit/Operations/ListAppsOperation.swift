// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct ListAppsOperation: APIOperation {

    struct Options {
        var bundleIds: [String] = []
        var names: [String] = []
        var skus: [String] = []
        var limit: Int?
    }

    let service: BagbutikService
    let options: Options
   
    func execute() async throws -> [App] {
        var filters: [ListAppsV1.Filter] = []

        if options.bundleIds.isNotEmpty { filters.append(.bundleId(options.bundleIds)) }
        if options.names.isNotEmpty { filters.append(.name(options.names)) }
        if options.skus.isNotEmpty { filters.append(.sku(options.skus)) }

        let limits = options.limit.map { [ListAppsV1.Limit.limit($0)] }
        
        guard limits != nil else {
            return try await service.requestAllPages(.listAppsV1(filters: filters)).data
        }

        return try await service
            .request(.listAppsV1(filters: filters, limits: limits))
            .data
    }
}
