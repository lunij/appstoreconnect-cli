// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct ModifyUserInfoCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "modify",
        abstract: "Change a user's role, app visibility information, or other account details."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The email of the user to find.")
    var email: String

    @OptionGroup()
    var userInfo: UserInfoArguments

    func validate() throws {
        if userInfo.bundleIds.isEmpty, userInfo.allAppsVisible == false {
            throw ValidationError("Invalid Input: If you set allAppsVisible to false, you must provide at least one value for the visibleApps relationship.")
        }
    }

    func run() async throws {
        let service = try makeService()

        let userId = try await GetUserInfoOperation(
            service: service,
            options: .init(email: email, includeVisibleApps: false)
        )
        .execute()
        .id

        let user = try await ModifyUserOperation(
            service: service,
            options: .init(
                userId: userId,
                allAppsVisible: userInfo.allAppsVisible,
                provisioningAllowed: userInfo.provisioningAllowed,
                roles: userInfo.roles,
                appsVisibleIds: userInfo.bundleIds
            )
        )
        .execute()

        try User(user, visibleApps: [])
            .render(options: common.outputOptions)
    }
}
