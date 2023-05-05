// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine

struct ListBundleIdsOperation: APIOperation {
    struct Options {
        let identifiers: [String]
        let names: [String]
        let platforms: [String]
        let seedIds: [String]
        let limit: Int?
    }

    private let options: Options

    init(options: Options) {
        self.options = options
    }

    typealias BundleId = AppStoreConnect_Swift_SDK.BundleId

    func execute(with requestor: EndpointRequestor) throws -> AnyPublisher<[BundleId], Error> {
        let platforms = options.platforms.compactMap(Platform.init(rawValue:))

        var filters: [BundleIds.Filter] = []

        if options.identifiers.isNotEmpty { filters.append(.identifier(options.identifiers)) }
        if options.names.isNotEmpty { filters.append(.name(options.names)) }
        if options.platforms.isNotEmpty { filters.append(.platform(platforms)) }
        if options.seedIds.isNotEmpty { filters.append(.seedId(options.seedIds)) }

        guard let limit = options.limit else {
            return requestor.requestAllPages {
                .listBundleIds(filter: filters, next: $0)
            }
            .map { $0.flatMap(\.data) }
            .eraseToAnyPublisher()
        }

        return requestor.request(
            .listBundleIds(filter: filters, limit: limit)
        )
        .map(\.data)
        .eraseToAnyPublisher()
    }
}

extension BundleIdsResponse: PaginatedResponse {}
