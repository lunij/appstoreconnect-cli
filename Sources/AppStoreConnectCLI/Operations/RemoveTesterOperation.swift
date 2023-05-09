// Copyright 2023 Itty Bitty Apps Pty Ltd

struct RemoveTesterOperation: APIOperation {
    struct Options {
        let removeStrategy: RemoveStrategy
    }

    enum RemoveStrategy {
        case removeTestersFromGroup(testerIds: [String], groupId: String)
        case removeTesterFromGroups(testerId: String, groupIds: [String])
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws {
        switch options.removeStrategy {
        case let .removeTesterFromGroups(testerId, groupIds):
            try await service.request(.deleteBetaGroupsForBetaTesterV1(id: testerId, requestBody: .init(data: groupIds.map { .init(id: $0) })))
        case let .removeTestersFromGroup(testerIds, groupId):
            try await service.request(.deleteBetaTestersForBetaGroupV1(id: groupId, requestBody: .init(data: testerIds.map { .init(id: $0) })))
        }
    }
}
