// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct DeleteBetaTesterCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "delete",
        abstract: "Delete beta testers"
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "Beta testers' emails")
    var emails: [String]

    func validate() throws {
        if emails.isEmpty {
            throw ValidationError("Missing expected argument '<emails>'")
        }
    }

    func run() async throws {
        let service = try makeService()

        let betaTesters = try await emails
            .removeDuplicates()
            .asyncMap {
                try await GetBetaTesterOperation(
                    service: service,
                    options: .init(identifier: .email($0))
                )
                .execute()
            }

        try await DeleteBetaTestersOperation(
            service: service,
            options: .init(ids: betaTesters.map(\.id))
        )
        .execute()
    }
}
