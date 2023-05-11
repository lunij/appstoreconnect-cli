// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Bagbutik_TestFlight

struct ListPreReleaseVersionsOperation: APIOperation {
    struct Options {
        var filterAppIds: [String] = []
        var filterVersions: [String] = []
        var filterPlatforms: [Platform] = []
        var sorts: [ListPreReleaseVersionsV1.Sort] = []
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> [PreReleaseVersionsResponse] {
        var filters: [ListPreReleaseVersionsV1.Filter] = []

        if options.filterAppIds.isNotEmpty { filters.append(.app(options.filterAppIds)) }
        if options.filterVersions.isNotEmpty { filters.append(.version(options.filterVersions)) }
        if options.filterPlatforms.isNotEmpty { filters.append(.platform(options.filterPlatforms)) }

        return try await service
            .requestAllPages(
                .listPreReleaseVersionsV1(
                    filters: filters.nilIfEmpty,
                    includes: [.app],
                    sorts: options.sorts.nilIfEmpty
                )
            )
            .responses
    }
}
