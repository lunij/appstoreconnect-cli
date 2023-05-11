// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import ArgumentParser
import Combine
import Foundation
import struct Model.Device
import SwiftyTextTable
import Yams

enum DeviceError: Error, LocalizedError {
    case notFound(String)

    var failureReason: String? {
        switch self {
        case let .notFound(udid):
            return "Unable to find device with UDID of '\(udid)'."
        }
    }
}

struct ReadDeviceInfoCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "read",
        abstract: "Get information for a specific device registered to your team."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The UDID of the device to find.")
    var udid: String

    func run() throws {
        let service = try makeService()

        let request = APIEndpoint.listDevices(
            filter: [.udid([udid])]
        )

        let device = try service.request(request)
            .map(\.data)
            .tryMap { devices -> AppStoreConnect_Swift_SDK.Device in
                guard let device = devices.first(where: { $0.attributes.udid == self.udid }) else {
                    throw DeviceError.notFound(self.udid)
                }

                return device
            }
            .map(Device.init)
            .await()

        device.render(options: common.outputOptions)
    }
}
