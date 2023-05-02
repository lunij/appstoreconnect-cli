// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import struct Model.BundleId

struct ReadBundleIdCommand: CommonParsableCommand {
    public static var configuration = CommandConfiguration(
        commandName: "read",
        abstract: "Get information about a specific bundle ID."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The reverse-DNS bundle ID identifier to read. Must be unique. (eg. com.example.app)")
    var identifier: String

    func run() async throws {
        let service = try makeService()
        let bundleId = try await ReadBundleIdOperation(
            service: service,
            options: .init(bundleId: identifier)
        )
        .execute()

        Model
            .BundleId(bundleId)
            .render(options: common.outputOptions)
    }
}
