// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct ModifyDeviceCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "modify",
        abstract: "Update the name or status of a specific device."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The UDID of the device to find.")
    var udid: String

    @Argument(help: "The new name for the device.")
    var name: String

    @Argument(help: "The new status for the device: \(DeviceStatus.allValueStringsFormatted).")
    var status: DeviceStatus

    func run() async throws {
        let service = try makeService()
        let deviceId = try await service.deviceId(matching: udid)
        let device = try await service
            .request(.updateDeviceV1(id: deviceId, requestBody: .init(data: .init(
                id: deviceId,
                attributes: .init(name: name, status: status)
            ))))
            .data

        try Device(device).render(options: common.outputOptions)
    }
}

private extension BagbutikServiceProtocol {
    /// Find the opaque internal resource identifier for a Device  matching `udid`. Use this for reading, modifying and deleting Device resources.
    ///
    /// - parameter udid: The device UDID string.
    /// - returns: The App Store Connect API resource identifier for the Device UDID.
    func deviceId(matching udid: String) async throws -> String {
        let devices = try await request(.listDevicesV1(filters: [.udid([udid])]))
            .data
            .filter { $0.attributes?.udid == udid }

        if devices.count > 1 {
            throw DeviceError.deviceNotUnique(udid)
        }

        guard let device = devices.first else {
            throw DeviceError.deviceNotFound(udid)
        }

        return device.id
    }
}
