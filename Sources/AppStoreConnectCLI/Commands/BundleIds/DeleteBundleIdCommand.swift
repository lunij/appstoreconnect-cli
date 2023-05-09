// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct DeleteBundleIdCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "delete",
        abstract: "Delete a bundle ID that is used for app development."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The reverse-DNS bundle ID identifier to delete. Must be unique. (eg. com.example.app)")
    var identifier: String

    func run() async throws {
        let service = try makeService()
        let bundleId = try await ReadBundleIdOperation(
            service: service,
            options: .init(bundleId: identifier)
        )
        .execute()

        try await DeleteBundleIdOperation(
            service: service,
            options: .init(resourceId: bundleId.id)
        )
        .execute()
    }
}
