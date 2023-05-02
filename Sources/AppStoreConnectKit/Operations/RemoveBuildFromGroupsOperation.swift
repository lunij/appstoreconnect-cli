// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct RemoveBuildFromGroupsOperation: APIOperation {

    struct Options {
        let buildId: String
        let groupIds: [String]
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> Void {
        _ = try await service.request(.deleteBetaGroupsForBuildV1(
            id: options.buildId,
            requestBody: .init(data: options.groupIds.map { .init(id: $0) })
        ))
    }
}
