// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik

struct CreateProfileCommand: CommonParsableCommand {

    static var configuration = CommandConfiguration(
        commandName: "create",
        abstract: "Create a new provisioning profile."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The name of the provisioning profile to create.")
    var name: String

    @Argument(help: "The type of profile to create: \(ProfileType.allValueStringsFormatted).")
    var profileType: ProfileType

    @Argument(help: "The reverse-DNS bundle ID identifier to associate with this profile (must already exist).")
    var bundleId: String

    @Option(
        parsing: .upToNextOption,
        help: "The serial numbers of Certificates. (eg. 1A2B3C4D5E6FD798)"
    )
    var certificateSerialNumbers: [String]

    @Option(
        parsing: .upToNextOption,
        help: "The UDIDs of Devices. Required for development profiles only."
    )
    var devicesUdids: [String] = []

    func validate() throws {
        if profileType.isDistributionProfile {
            if devicesUdids.isNotEmpty {
                throw ValidationError("Distribution Profiles are not expected to contain device UDIDs.")
            }
        } else {
            if devicesUdids.isEmpty {
                throw ValidationError("Device UDIDs are required for Development Profiles.")
            }
        }
    }

    func run() async throws {
        let service = try makeService()

        let bundleIdResourceId = try await ReadBundleIdOperation(
            service: service,
            options: .init(bundleId: bundleId)
        )
        .execute()
        .id

        let deviceIds = try await ListDevicesOperation(
            service: service,
            options: .init(
                filterName: [],
                filterPlatform: [],
                filterUDID: devicesUdids
            )
        )
        .execute()
        .map { $0.id }

        let certificateIds = try await certificateSerialNumbers.asyncCompactMap {
            try await ListCertificatesOperation(
                service: service,
                options: .init(filterSerial: $0)
            )
            .execute()
            .first?
            .id
        }

        let profile = try await CreateProfileOperation(
            service: service,
            options: .init(
                name: name,
                bundleIdResourceId: bundleIdResourceId,
                profileType: profileType,
                certificateIds: certificateIds,
                deviceIds: deviceIds
            )
        )
        .execute()

        [profile].render(options: common.outputOptions)
    }
}
