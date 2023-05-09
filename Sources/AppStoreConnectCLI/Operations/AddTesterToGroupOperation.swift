// Copyright 2023 Itty Bitty Apps Pty Ltd

struct AddTesterToGroupOperation: APIOperation {
    struct Options {
        enum AddStrategy {
            case addTestersToGroup(testerIds: [String], groupId: String)
            case addTesterToGroups(testerId: String, groupIds: [String])
        }

        let addStrategy: AddStrategy
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws {
        switch options.addStrategy {
        case let .addTestersToGroup(testerIds, groupId):
            try await service.request(.createBetaTestersForBetaGroupV1(id: groupId, requestBody: .init(data: testerIds.map { .init(id: $0) })))
        case let .addTesterToGroups(testerId, groupIds):
            try await service.request(.createBetaGroupsForBetaTesterV1(id: testerId, requestBody: .init(data: groupIds.map { .init(id: $0) })))
        }
    }
}
