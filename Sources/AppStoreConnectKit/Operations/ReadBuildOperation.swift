// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct ReadBuildOperation: APIOperation {

    struct Options {
        let appId: String
        let buildNumber: String
        let preReleaseVersion: String
    }

    enum Error: Swift.Error, CustomStringConvertible, Equatable {
        case buildNotFound
        case multipleBuildsFound

        var description: String {
            switch self {
            case .buildNotFound:
                return "No build found"
            case .multipleBuildsFound:
                return "Multiple builds found"
            }
        }
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> (build: Build, includes: [BuildsResponse.Included]) {
        var filters: [ListBuildsV1.Filter] = []

        if options.preReleaseVersion.isNotEmpty {
            filters += [.preReleaseVersion_version([options.preReleaseVersion])]
        }

        if options.buildNumber.isNotEmpty {
            filters += [.version([options.buildNumber])]
        }

        if options.appId.isNotEmpty {
            filters += [.app([options.appId])]
        }

        let response = try await service.request(.listBuildsV1(
            filters: filters,
            includes: [.app, .betaAppReviewSubmission, .buildBetaDetail, .preReleaseVersion]
        ))

        if response.data.count > 1 {
            throw Error.multipleBuildsFound
        }

        guard let build = response.data.first else {
            throw Error.buildNotFound
        }

        return (build: build, includes: response.included ?? [])
    }
}
