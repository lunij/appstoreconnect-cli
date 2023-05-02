// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik
import struct Model.BetaGroup

struct ReadBetaGroupCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "read",
        abstract: "Read a beta group"
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(
        help: """
        The reverse-DNS bundle ID of the app which the group should be associated with. \
        Must be unique. (eg. com.example.app)
        """
    )
    var bundleId: String

    @Argument(help: "The name of the beta group.")
    var groupName: String

    func run() async throws {
        let service = try makeService()

        let app = try await ReadAppOperation(
            service: service,
            options: .init(identifier: .bundleId(bundleId))
        )
        .execute()

        let betaGroup = try await GetBetaGroupOperation(
            service: service,
            options: .init(appId: app.id, bundleId: bundleId, betaGroupName: groupName)
        )
        .execute()

        Model
            .BetaGroup(betaGroup, app: app)
            .render(options: common.outputOptions)
    }
}
