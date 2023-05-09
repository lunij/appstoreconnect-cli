// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct GetUserInfoCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "info",
        abstract: "Get information about a user on your team, such as name, roles, and app visibility."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The email of the user to find.")
    var email: String

    @Flag(help: "Include visible apps in results.")
    var includeVisibleApps = false

    func run() async throws {
        let service = try makeService()

        let user = try await GetUserInfoOperation(
            service: service,
            options: .init(
                email: email,
                includeVisibleApps: includeVisibleApps
            )
        )
        .execute()

        try User(user, visibleApps: [])
            .render(options: common.outputOptions)
    }
}
