// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Model

struct ModifyBetaGroupCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "modify",
        abstract: "Modify a beta group, only the specified options are modified"
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

    @Argument(
        help: ArgumentHelp(
            "The current name of the beta group to be modified",
            discussion: """
            This name will be used to search for a unique beta group matching the specified \
            app bundle id
            """,
            valueName: "beta-group-name"
        )
    )
    var currentGroupName: String

    @Option(
        name: .customLong("name"),
        help: "Modifies the name of the beta group"
    )
    var newGroupName: String?

    @Option(help: "Enables or disables the public link")
    var publicLinkEnabled: Bool?

    @Option(help: "Adjusts the public link limit")
    var publicLinkLimit: Int?

    @Option(help: "Enables or disables whether to use a public link limit")
    var publicLinkLimitEnabled: Bool?

    func run() async throws {
        let service = try makeService()

        let app = try await GetAppOperation(
            service: service,
            options: .init(bundleId: bundleId)
        )
        .execute()

        let betaGroup = try await GetBetaGroupOperation(
            service: service,
            options: .init(appId: app.id, bundleId: bundleId, betaGroupName: currentGroupName)
        )
        .execute()

        let updatedBetaGroup = try await UpdateBetaGroupOperation(
            service: service,
            options: .init(
                betaGroup: betaGroup,
                betaGroupName: newGroupName,
                publicLinkEnabled: publicLinkEnabled,
                publicLinkLimit: publicLinkLimit,
                publicLinkLimitEnabled: publicLinkLimitEnabled
            )
        )
        .execute()

        Model
            .BetaGroup(updatedBetaGroup, app: app)
            .render(options: common.outputOptions)
    }
}
