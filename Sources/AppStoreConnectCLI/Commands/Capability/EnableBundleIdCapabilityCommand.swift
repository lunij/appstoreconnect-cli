// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct EnableBundleIdCapabilityCommand: CommonParsableCommand {
    public static var configuration = CommandConfiguration(
        commandName: "enable",
        abstract: "Enable a capability for a bundle ID."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The reverse-DNS bundle ID identifier to delete. Must be unique. (eg. com.example.app)")
    var bundleId: String

    @Argument(help: ArgumentHelp("Bundle Id capability type.", discussion: "List of \(CapabilityType.allValueStrings.formatted(.list(type: .or)))"))
    var capabilityType: [CapabilityType]

    #warning("CapabilitySetting")

    func run() async throws {
        let service = try makeService()
        let bundleId = try await ReadBundleIdOperation(
            service: service,
            options: .init(bundleId: bundleId)
        )
        .execute()

        let result = try await withThrowingTaskGroup(of: BundleIdCapability.self) { group in
            for type in capabilityType {
                group.addTask {
                    try await BundleIdCapability(
                        EnableBundleIdCapabilityOperation(
                            service: service,
                            options: .init(bundleIdResourceId: bundleId.id, capabilityType: type)
                        )
                        .execute()
                    )
                }
            }

            var values = [BundleIdCapability]()
            for try await value in group {
                values.append(value)
            }

            return values
        }

        #warning("should list capabilities on bundleId")

        try result.render(options: common.outputOptions)
    }
}
