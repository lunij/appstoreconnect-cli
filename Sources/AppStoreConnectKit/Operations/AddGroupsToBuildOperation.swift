// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct AddGroupsToBuildOperation: APIOperation {

    struct Options {
        let groupIds: [String]
        let buildId: String
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws {
        _ = try await service.request(.createBetaGroupsForBuildV1(
            id: options.buildId,
            requestBody: .init(data: options.groupIds.map { .init(id: $0) })
        ))
    }
}
