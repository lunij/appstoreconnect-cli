// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine
import Foundation

struct CreateBetaGroupOperation: APIOperation {
    struct Options {
        let app: AppStoreConnect_Swift_SDK.App
        let groupName: String
        let publicLinkEnabled: Bool
        let publicLinkLimit: Int?
    }

    typealias BetaGroup = AppStoreConnect_Swift_SDK.BetaGroup
    typealias App = AppStoreConnect_Swift_SDK.App

    typealias Output = (app: App, betaGroup: BetaGroup)

    private let options: Options

    init(options: Options) {
        self.options = options
    }

    func execute(with requestor: EndpointRequestor) -> AnyPublisher<Output, Error> {
        let endpoint = APIEndpoint.create(
            betaGroupForAppWithId: options.app.id,
            name: options.groupName,
            publicLinkEnabled: options.publicLinkEnabled,
            publicLinkLimit: options.publicLinkLimit,
            publicLinkLimitEnabled: options.publicLinkLimit != nil
        )

        return requestor
            .request(endpoint)
            .map { (self.options.app, $0.data) }
            .eraseToAnyPublisher()
    }
}
