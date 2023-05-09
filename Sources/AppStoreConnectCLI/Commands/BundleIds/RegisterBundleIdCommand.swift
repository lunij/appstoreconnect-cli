// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct RegisterBundleIdCommand: CommonParsableCommand {
    typealias Platform = Bagbutik_Models.BundleIdPlatform

    static var configuration = CommandConfiguration(
        commandName: "register",
        abstract: "Register a new bundle ID for app development."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The reverse-DNS bundle ID identifier. Must be unique. (eg. com.example.app)")
    var identifier: String

    @Argument(help: "The new name for the bundle identifier.")
    var name: String

    @Option(
        help: "The platform of the bundle identifier. One of \(Platform.allValueStrings.formatted(.list(type: .or))).",
        completion: .list(Platform.allValueStrings)
    )
    var platform: Platform = .universal

    func run() async throws {
        let service = try makeService()
        let bundleId = try await RegisterBundleIdOperation(
            service: service,
            options: .init(bundleId: identifier, name: name, platform: platform)
        )
        .execute()

        try BundleId(bundleId)
            .render(options: common.outputOptions)
    }
}
