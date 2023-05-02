// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct AddTesterToGroupOperation: APIOperation {

    struct Options {
        enum AddStrategy {
            case addTestersToGroup(testerIds: [String], groupId: String)
            case addTesterToGroups(testerId: String, groupIds: [String])
        }

        let addStrategy: AddStrategy
    }

    let service: BagbutikService
    let options: Options

    private var request: Request<EmptyResponse, ErrorResponse> {
        switch options.addStrategy {
        case let .addTestersToGroup(testerIds, groupId):
            return .createBetaTestersForBetaGroupV1(id: groupId, requestBody: .init(data: testerIds.map { .init(id: $0) }))
        case let .addTesterToGroups(testerId, groupIds):
            return .createBetaGroupsForBetaTesterV1(id: testerId, requestBody: .init(data: groupIds.map { .init(id: $0) }))
        }
    }

    func execute() async throws {
        _ = try await service.request(request)
    }
}
