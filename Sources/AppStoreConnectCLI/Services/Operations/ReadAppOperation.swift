// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine
import Foundation

struct ReadAppOperation: APIOperation {
    struct Options {
        let identifier: AppLookupIdentifier
        var shouldMatchExactly: Bool = true
    }

    enum Error: LocalizedError {
        case notFound(String)
        case notUnique(String)

        var errorDescription: String? {
            switch self {
            case let .notFound(identifier):
                return "App with provided identifier '\(identifier)' doesn't exist."
            case let .notUnique(identifier):
                return "App with provided identifier '\(identifier)' not unique."
            }
        }
    }

    typealias App = AppStoreConnect_Swift_SDK.App

    private let options: Options

    init(options: Options) {
        self.options = options
    }

    func execute(with requestor: EndpointRequestor) -> AnyPublisher<App, Swift.Error> {
        let result: AnyPublisher<App, Swift.Error>

        switch options.identifier {
        case let .appId(appId):
            result = requestor.request(.app(withId: appId))
                .map(\.data)
                .eraseToAnyPublisher()
        case let .bundleId(bundleId):
            let endpoint: APIEndpoint = .apps(filters: [.bundleId([bundleId])])

            result = requestor.request(endpoint)
                .tryMap { (response: AppsResponse) throws -> App in
                    switch response.data.count {
                    case 0:
                        throw Error.notFound(bundleId)
                    case 1:
                        return response.data.first!
                    default:
                        guard options.shouldMatchExactly else {
                            throw Error.notUnique(bundleId)
                        }

                        guard let match = response.data.first(where: {
                            $0.attributes?.bundleId == bundleId
                        }) else {
                            throw Error.notFound(bundleId)
                        }

                        return match
                    }
                }
                .eraseToAnyPublisher()
        }

        return result
    }
}
