// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import struct Model.Profile

struct ListProfilesOperation: APIOperation {

    struct Options {
        var ids: [String] = []
        var filterName: [String] = []
        var filterProfileState: ProfileState?
        var filterProfileTypes: [ProfileType] = []
        var sorts: [ListProfilesV1.Sort] = []
        var limit: Int?
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> [Model.Profile] {
        var filters: [ListProfilesV1.Filter] = []

        if options.filterName.isNotEmpty { filters.append(.name(options.filterName)) }
        if options.filterProfileTypes.isNotEmpty { filters.append(.profileType(options.filterProfileTypes)) }
        if let filterProfileState = options.filterProfileState { filters.append(.profileState([filterProfileState])) }
        if options.ids.isNotEmpty { filters.append(.id(options.ids)) }

        let responses = try await service.requestAllPages(.listProfilesV1(
            filters: filters,
            includes: [.bundleId, .certificates, .devices],
            sorts: options.sorts.nilIfEmpty,
            limits: options.limit.map { [.limit($0)] }
        ))
        .responses

        return responses.flatMap { response in
            response.data.map {
                Model.Profile($0, includes: response.included ?? [])
            }
        }
    }
}
