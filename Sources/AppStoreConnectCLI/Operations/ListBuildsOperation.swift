// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Bagbutik_TestFlight

struct ListBuildsOperation: APIOperation {
    typealias Filter = ListBuildsV1.Filter

    struct Options {
        let filterAppIds: [String]
        let filterExpired: [String]
        let filterPreReleaseVersions: [String]
        let filterBuildNumbers: [String]
        let filterProcessingStates: [BuildProcessingState]
        let filterBetaReviewStates: [BetaReviewState]
        let limit: Int?
    }

    var filters: [Filter] {
        var filters: [Filter] = []
        filters += options.filterAppIds.isEmpty ? [] : [.app(options.filterAppIds)]
        filters += options.filterPreReleaseVersions.isEmpty ? [] : [.preReleaseVersion_version(options.filterPreReleaseVersions)]
        filters += options.filterBuildNumbers.isEmpty ? [] : [.version(options.filterBuildNumbers)]
        filters += options.filterExpired.isEmpty ? [] : [.expired(options.filterExpired)]
        filters += options.filterProcessingStates.isEmpty ? [] : [.processingState(options.filterProcessingStates)]
        filters += options.filterBetaReviewStates.isEmpty ? [] : [.betaAppReviewSubmission_betaReviewState(options.filterBetaReviewStates)]
        return filters
    }

    private var limits: [ListBuildsV1.Limit]? {
        options.limit.map { limit in
            [.individualTesters(limit), .betaBuildLocalizations(limit)]
        }
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> [(Bagbutik_Models.Build, [BuildsResponse.Included])] {
        let responses = try await service
            .requestAllPages(.listBuildsV1(
                filters: filters,
                includes: [.app, .betaAppReviewSubmission, .buildBetaDetail, .preReleaseVersion],
                sorts: [.uploadedDateAscending],
                limits: limits
            ))
            .responses

        return responses.flatMap { response in
            response.data.map { build in
                (build, response.included ?? [])
            }
        }
    }
}
