// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import struct Model.BundleId

struct ModifyBundleIdCommand: CommonParsableCommand {

    public static var configuration = CommandConfiguration(
        commandName: "modify",
        abstract: "Update a specific bundle ID's name."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The reverse-DNS bundle ID identifier. (eg. com.example.app)")
    var identifier: String

    @Argument(help: "The new name for the bundle identifier.")
    var name: String

    func run() async throws {
        let service = try makeService()
        let bundleId = try await ReadBundleIdOperation(
            service: service,
            options: .init(bundleId: identifier)
        )
        .execute()

        let updatedBundleId = try await ModifyBundleIdOperation(
            service: service,
            options: .init(resourceId: bundleId.id, name: name)
        )
        .execute()

        Model
            .BundleId(updatedBundleId)
            .render(options: common.outputOptions)
    }
}
