// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct RemoveTesterOperation: APIOperation {

    struct Options {
        let removeStrategy: RemoveStrategy
    }

    enum RemoveStrategy {
        case removeTestersFromGroup(testerIds: [String], groupId: String)
        case removeTesterFromGroups(testerId: String, groupIds: [String])
    }

    let service: BagbutikService
    let options: Options

    private var request: Request<EmptyResponse, ErrorResponse> {
        switch options.removeStrategy {
        case let .removeTesterFromGroups(testerId, groupIds):
            return .deleteBetaGroupsForBetaTesterV1(id: testerId, requestBody: .init(data: groupIds.map { .init(id: $0) }))
        case let .removeTestersFromGroup(testerIds, groupId):
            return .deleteBetaTestersForBetaGroupV1(id: groupId, requestBody: .init(data: testerIds.map { .init(id: $0) }))
        }
    }

    func execute() async throws {
        _ = try await service.request(request)
    }
}
