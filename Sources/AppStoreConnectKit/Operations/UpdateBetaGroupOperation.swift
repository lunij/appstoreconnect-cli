// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct UpdateBetaGroupOperation: APIOperation {
    struct Options {
        let betaGroup: BetaGroup
        let betaGroupName: String?
        let publicLinkEnabled: Bool?
        let publicLinkLimit: Int?
        let publicLinkLimitEnabled: Bool?
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> BetaGroup {
        try await service.request(.updateBetaGroupV1(
            id: options.betaGroup.id,
            requestBody: .init(data: .init(
                id: options.betaGroup.id,
                attributes: .init(
                    name: options.betaGroupName,
                    publicLinkEnabled: options.publicLinkEnabled,
                    publicLinkLimit: options.publicLinkLimit,
                    publicLinkLimitEnabled: options.publicLinkLimitEnabled
                )
            ))
        ))
        .data
    }
}
