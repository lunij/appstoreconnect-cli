// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import ArgumentParser
import Combine
import Foundation
import struct Model.Device

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

    @Argument(help: "The platform of the device to register \(Platform.allCases).")
    var platform: Platform

    func run() throws {
        let service = try makeService()

        let device = try service.request(APIEndpoint.registerNewDevice(name: name, platform: platform, udid: udid))
            .map(Device.init)
            .await()

        device.render(options: common.outputOptions)
    }
}
