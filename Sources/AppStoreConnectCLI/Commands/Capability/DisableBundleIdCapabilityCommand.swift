// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct DisableBundleIdCapabilityCommand: CommonParsableCommand {
    public static var configuration = CommandConfiguration(
        commandName: "disable",
        abstract: "Disable a capability for a bundle ID."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The reverse-DNS bundle ID identifier to delete. Must be unique. (eg. com.example.app)")
    var bundleId: String

    @Argument(
        help: ArgumentHelp("Bundle Id capability type.", discussion: "List of \(CapabilityType.allValueStrings.formatted(.list(type: .or)))"),
        completion: .list(CapabilityType.allValueStrings)
    )
    var capabilityType: [CapabilityType]

    func run() async throws {
        let service = try makeService()
        let bundleIdResourceId = try await ReadBundleIdOperation(
            service: service,
            options: .init(bundleId: bundleId)
        )
        .execute()
        .id

        let capabilityIdentifiers = try await ListCapabilitiesOperation(
            service: service,
            options: .init(bundleIdResourceId: bundleIdResourceId)
        )
        .execute()
        .filter {
            if let type = $0.attributes?.capabilityType {
                return capabilityType.contains { $0 == type }
            }
            return false
        }
        .map(\.id)

        await withThrowingTaskGroup(of: Void.self) { group in
            for id in capabilityIdentifiers {
                group.addTask {
                    try await DisableBundleIdCapabilityOperation(service: service, options: .init(capabilityId: id)).execute()
                }
            }
        }

        #warning("should list capabilities on bundleId")
    }
}
