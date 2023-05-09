// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct DeleteBetaGroupCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "delete",
        abstract: "Delete a beta group"
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(
        help: """
        The reverse-DNS bundle ID of the app which the group is associated with. \
        Must be unique. (eg. com.example.app)
        """
    )
    var appBundleId: String

    @Argument(
        help: ArgumentHelp(
            "The name of the beta group to be deleted",
            discussion: """
            This name will be used to search for a unique beta group matching the specified \
            app bundle id
            """
        )
    )
    var betaGroupName: String

    func run() async throws {
        let service = try makeService()

        let appId = try await GetAppOperation(
            service: service,
            options: .init(bundleId: appBundleId)
        )
        .execute()
        .id

        let betaGroup = try await GetBetaGroupOperation(
            service: service,
            options: .init(appId: appId, bundleId: appBundleId, betaGroupName: betaGroupName)
        )
        .execute()

        try await DeleteBetaGroupOperation(
            service: service,
            options: .init(betaGroupId: betaGroup.id)
        )
        .execute()
    }
}
