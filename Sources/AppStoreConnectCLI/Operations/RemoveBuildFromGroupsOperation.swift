// Copyright 2023 Itty Bitty Apps Pty Ltd

struct RemoveBuildFromGroupsOperation: APIOperation {
    struct Options {
        let buildId: String
        let groupIds: [String]
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws {
        try await service.request(.deleteBetaGroupsForBuildV1(
            id: options.buildId,
            requestBody: .init(data: options.groupIds.map { .init(id: $0) })
        ))
    }
}
