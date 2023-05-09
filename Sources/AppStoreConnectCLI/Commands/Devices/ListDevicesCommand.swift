// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models
import Bagbutik_Provisioning

struct ListDevicesCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "list",
        abstract: "Find and list devices."
    )

    @OptionGroup()
    var common: CommonOptions

    @Option(help: "Limit the number of devices to return (maximum 200).")
    var limit: Int?

    @Option(
        parsing: .unconditional,
        help: ArgumentHelp(
            "Sort the results using one or more of the following values: \(ListDevicesV1.Sort.allValueStringsFormatted)",
            discussion: "The `-` prefix indicates descending order."
        ),
        transform: { $0.components(separatedBy: ",").compactMap(ListDevicesV1.Sort.init(argument:)) }
    )
    var sort: [ListDevicesV1.Sort] = []

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter the results by the specified device name.",
            valueName: "name"
        ),
        transform: { $0.lowercased() }
    )
    var filterName: [String] = []

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter the results by the following platforms: \(BundleIdPlatform.allValueStringsFormatted)",
            valueName: "platform"
        )
    )
    var filterPlatform: [BundleIdPlatform] = []

    @Option(
        help: ArgumentHelp(
            "Filter the results by device status: \(DeviceStatus.allValueStringsFormatted).",
            valueName: "status"
        )
    )
    var filterStatus: DeviceStatus?

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter the results by the specified device udid.",
            valueName: "udid"
        ),
        transform: { $0.lowercased() }
    )
    var filterUDID: [String] = []

    func run() async throws {
        let service = try makeService()
        let devices = try await ListDevicesOperation(
            service: service,
            options: .init(
                filterName: filterName,
                filterPlatform: filterPlatform,
                filterUDID: filterUDID,
                filterStatus: filterStatus,
                sorts: sort.nilIfEmpty,
                limit: limit
            )
        )
        .execute()
        .map(Device.init)

        try devices.render(options: common.outputOptions)
    }
}

extension ListDevicesV1.Sort: ExpressibleByArgument {}
