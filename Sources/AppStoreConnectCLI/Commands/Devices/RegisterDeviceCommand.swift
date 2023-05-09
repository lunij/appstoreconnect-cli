// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct RegisterDeviceCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "register",
        abstract: "Register a new device for app development."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The UDID of the device to register.")
    var udid: String

    @Argument(help: "The name of the device to register.")
    var name: String

    @Argument(help: "The platform of the device to register: \(BundleIdPlatform.allValueStringsFormatted)")
    var platform: BundleIdPlatform

    func run() async throws {
        let service = try makeService()

        let device = try await service.request(.createDeviceV1(requestBody: .init(data: .init(
            attributes: .init(name: name, platform: platform, udid: udid)
        ))))
        .data

        try Device(device).render(options: common.outputOptions)
    }
}
