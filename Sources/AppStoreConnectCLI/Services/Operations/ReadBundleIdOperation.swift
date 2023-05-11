// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine
import Foundation

struct ReadBundleIdOperation: APIOperation {
    struct Options {
        let bundleId: String
    }

    enum Error: LocalizedError {
        case couldNotFindBundleId(String)
        case bundleIdNotUnique(String)

        var errorDescription: String? {
            switch self {
            case let .couldNotFindBundleId(bundleId):
                return "Couldn't find Bundle ID: '\(bundleId)'."
            case let .bundleIdNotUnique(bundleId):
                return "The Bundle ID you provided '\(bundleId)' is not unique."
            }
        }
    }

    private let options: Options

    init(options: Options) {
        self.options = options
    }

    func execute(with requestor: EndpointRequestor) -> AnyPublisher<BundleId, Swift.Error> {
        requestor.request(
            .listBundleIds(
                filter: [.identifier([options.bundleId])]
            )
        )
        .tryMap {
            let data = $0.data.filter { $0.attributes?.identifier == self.options.bundleId }
            switch data.count {
            case 0:
                throw Error.couldNotFindBundleId(self.options.bundleId)
            case 1:
                return data.first!
            default:
                throw Error.bundleIdNotUnique(self.options.bundleId)
            }
        }
        .eraseToAnyPublisher()
    }
}
