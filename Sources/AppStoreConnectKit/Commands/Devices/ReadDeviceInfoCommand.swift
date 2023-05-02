// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik
import struct Model.Device

struct ReadDeviceInfoCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "read",
        abstract: "Get information for a specific device registered to your team."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The UDID of the device to find.")
    var udid: String

    func run() async throws {
        let service = try makeService()
        let devices = try await service
            .request(.listDevicesV1(filters: [.udid([udid])]))
            .data
            .filter { $0.attributes?.udid == udid }

        if devices.count > 1 {
            throw DeviceError.deviceNotUnique(udid)
        }

        guard let device = devices.first else {
            throw DeviceError.deviceNotFound(udid)
        }

        Model.Device(device).render(options: common.outputOptions)
    }

}
