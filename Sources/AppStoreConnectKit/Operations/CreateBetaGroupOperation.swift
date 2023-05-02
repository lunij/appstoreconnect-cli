// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import struct Model.BetaGroup

struct CreateBetaGroupOperation: APIOperation {

    struct Options {
        let app: App
        let groupName: String
        let publicLinkEnabled: Bool
        let publicLinkLimit: Int?
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> Model.BetaGroup {
        let betaGroup = try await service
            .request(.createBetaGroupV1(requestBody: .init(data: .init(
                attributes: .init(
                    name: options.groupName,
                    publicLinkEnabled: options.publicLinkEnabled,
                    publicLinkLimit: options.publicLinkLimit,
                    publicLinkLimitEnabled: options.publicLinkLimit != nil
                ),
                relationships: .init(
                    app: .init(data: .init(id: options.app.id))
                )
            ))))
            .data

        return .init(betaGroup, app: options.app)
    }
}
