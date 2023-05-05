// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine

struct ListDevicesOperation: APIOperation {
    struct Options {
        let filterName: [String]
        let filterPlatform: [Platform]
        let filterUDID: [String]
        let filterStatus: DeviceStatus?
        let sort: Devices.Sort?
        let limit: Int?
    }

    private let options: Options

    init(options: Options) {
        self.options = options
    }

    func execute(with requestor: EndpointRequestor) throws -> AnyPublisher<[Device], Error> {
        var filters = [Devices.Filter]()

        if options.filterName.isNotEmpty { filters.append(.name(options.filterName)) }
        if options.filterPlatform.isNotEmpty { filters.append(.platform(options.filterPlatform)) }
        if options.filterUDID.isNotEmpty { filters.append(.udid(options.filterUDID)) }
        if let filterStatus = options.filterStatus { filters.append(.status([filterStatus])) }

        let sort = [options.sort].compactMap { $0 }

        guard let limit = options.limit else {
            return requestor.requestAllPages {
                .listDevices(
                    filter: filters,
                    sort: sort,
                    next: $0
                )
            }
            .map { $0.flatMap(\.data) }
            .eraseToAnyPublisher()
        }

        return requestor.request(
            .listDevices(
                filter: filters,
                sort: sort,
                limit: limit
            )
        )
        .map(\.data)
        .eraseToAnyPublisher()
    }
}

extension DevicesResponse: PaginatedResponse {}
