// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct ReadAppOperation: APIOperation {

    struct Options {
        let identifier: AppLookupIdentifier
        var shouldMatchExactly: Bool = true
    }

    enum Error: Swift.Error, CustomStringConvertible {
        case notFound(String)
        case notUnique(String)

        var description: String {
            switch self {
            case let .notFound(identifier):
                return "App with provided identifier '\(identifier)' doesn't exist."
            case let .notUnique(identifier):
                return "App with provided identifier '\(identifier)' not unique."
            }
        }
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> App {
        switch options.identifier {
        case let .appId(appId):
            return try await service.request(.getAppV1(id: appId)).data
                
        case let .bundleId(bundleId):
            let apps = try await service
                .requestAllPages(.listAppsV1(filters: [.bundleId([bundleId])]))
                .data

            if apps.count > 1, options.shouldMatchExactly {
                throw Error.notUnique(bundleId)
            }

            guard let app = apps.first else {
                throw Error.notFound(bundleId)
            }

            return app
        }
    }
}
