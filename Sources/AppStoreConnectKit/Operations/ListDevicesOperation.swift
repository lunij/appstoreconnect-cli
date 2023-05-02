// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct ListDevicesOperation: APIOperation {

    struct Options {
        var filterName: [String] = []
        var filterPlatform: [ListDevicesV1.Filter.Platform] = []
        var filterUDID: [String] = []
        var filterStatus: DeviceStatus?
        var sorts: [ListDevicesV1.Sort]?
        var limit: Int?
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> [Device] {
        var filters: [ListDevicesV1.Filter] = []

        if options.filterName.isNotEmpty { filters.append(.name(options.filterName)) }
        if options.filterPlatform.isNotEmpty { filters.append(.platform(options.filterPlatform)) }
        if options.filterUDID.isNotEmpty { filters.append(.udid(options.filterUDID)) }
        if let filterStatus = options.filterStatus { filters.append(.status([filterStatus])) }

        guard let limit = options.limit else {
            return try await service.requestAllPages(.listDevicesV1(
                filters: filters,
                sorts: options.sorts
            ))
            .data
        }

        return try await service.request(.listDevicesV1(
            filters: filters,
            sorts: options.sorts,
            limit: limit
        ))
        .data
    }
}
