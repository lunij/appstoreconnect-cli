// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct ReadAppCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "read",
        abstract: "Find and read app info"
    )

    @OptionGroup()
    var common: CommonOptions

    @OptionGroup()
    var appLookupArgument: AppLookupArgument

    func run() async throws {
        let service = try makeService()
        let app = try await ReadAppOperation(
            service: service,
            options: .init(identifier: appLookupArgument.identifier)
        )
        .execute()

        try App(app).render(options: common.outputOptions)
    }
}
