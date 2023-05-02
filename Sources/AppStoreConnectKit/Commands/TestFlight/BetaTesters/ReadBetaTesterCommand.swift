// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import struct Model.BetaTester

struct ReadBetaTesterCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "read",
        abstract: "Get information about a beta tester"
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The Beta tester's email address")
    var email: String

    @Option(help: "Number of included app resources to return.")
    var limitApps: Int?

    @Option(help: "Number of included build resources to return.")
    var limitBuilds: Int?

    @Option(help: "Number of included beta group resources to return.")
    var limitBetaGroups: Int?

    func run() async throws {
        let service = try makeService()
        let betaTester = try await GetBetaTesterOperation(
            service: service,
            options: .init(
                identifier: .email(email),
                limitApps: limitApps,
                limitBuilds: limitBuilds,
                limitBetaGroups: limitBetaGroups
            )
        )
        .execute()

        Model
            .BetaTester(betaTester)
            .render(options: common.outputOptions)
    }
}
