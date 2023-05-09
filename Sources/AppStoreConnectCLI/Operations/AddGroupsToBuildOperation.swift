// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_TestFlight

struct AddGroupsToBuildOperation: APIOperation {
    struct Options {
        let groupIds: [String]
        let buildId: String
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws {
        try await service.request(.createBetaGroupsForBuildV1(
            id: options.buildId,
            requestBody: .init(data: options.groupIds.map { .init(id: $0) })
        ))
    }
}
