// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct ListPreReleaseVersionsOperation: APIOperation {

    struct Options {
        var filterAppIds: [String] = []
        var filterVersions: [String] = []
        var filterPlatforms: [ListPreReleaseVersionsV1.Filter.Platform] = []
        var sorts: [ListPreReleaseVersionsV1.Sort] = []
    }

    typealias Filter = ListPreReleaseVersionsV1.Filter
    typealias Output = [(preReleaseVersion: PrereleaseVersion, includes: [PreReleaseVersionsResponse.Included])]

    let service: BagbutikService
    let options: Options

    func execute() async throws -> Output {
        var filters: [Filter] = []

        if options.filterAppIds.isNotEmpty { filters.append(.app(options.filterAppIds)) }
        if options.filterVersions.isNotEmpty { filters.append(.version(options.filterVersions)) }
        if options.filterPlatforms.isNotEmpty { filters.append(.platform(options.filterPlatforms)) }

        return try await service.requestAllPages(
            .listPreReleaseVersionsV1(
                filters: filters.nilIfEmpty,
                includes: [.app],
                sorts: options.sorts.nilIfEmpty
            )
        )
        .responses
        .flatMap { response in
            response.data.map { preReleaseVersion in
                (preReleaseVersion, response.included ?? [])
            }
        }
    }
}
