// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import struct Model.Profile

struct UpdateProfileUseCase {
    let service: BagbutikService

    func updateProfile(
        id: String,
        udidsToAdd: [String],
        udidsToRemove: [String],
        outputOptions: OutputOptions
    ) async throws {
        if udidsToAdd.isEmpty && udidsToRemove.isEmpty {
            throw Error.nothingToUpdate
        }

        let profile = try await ReadProfileOperation(service: service, options: .init(id: id)).execute()

        guard let profileName = profile.name else {
            throw Error.profileNameNotProvided
        }

        guard let bundleId = profile.bundleIds?.first else {
            throw Error.bundleIdNotIncluded
        }

        guard let certificates = profile.certificates else {
            throw Error.certificatesNotIncluded
        }

        guard let devices = profile.devices else {
            throw Error.devicesNotIncluded
        }

        guard let rawProfileType = profile.profileType else {
            throw Error.profileTypeMissing
        }

        guard let profileType = ProfileType(rawValue: rawProfileType) else {
            throw Error.profileTypeUnsupported(type: rawProfileType)
        }

        let deviceIds = try await updateDeviceIds(registeredIds: devices.map(\.id), udidsToAdd: udidsToAdd, udidsToRemove: udidsToRemove)

        try await deleteProfile(id: profile.id)

        let newProfile = try await CreateProfileOperation(
            service: service,
            options: .init(
                name: profileName,
                bundleIdResourceId: bundleId.id,
                profileType: profileType,
                certificateIds: certificates.map(\.id),
                deviceIds: deviceIds
            )
        )
        .execute()

        [newProfile].render(options: outputOptions)
    }

    private func updateDeviceIds(registeredIds: [String], udidsToAdd: [String], udidsToRemove: [String]) async throws -> [String] {
        let idsToAdd = try await ListDevicesOperation(
            service: service,
            options: .init(filterUDID: udidsToAdd)
        )
        .execute()
        .map(\.id)

        let idsToRemove = try await ListDevicesOperation(
            service: service,
            options: .init(filterUDID: udidsToRemove)
        )
        .execute()
        .map(\.id)

        return (registeredIds + idsToAdd)
            .removeDuplicates()
            .filter { idsToRemove.contains($0) }
    }

    private func deleteProfile(id: String) async throws {
        _ = try await service.request(.deleteProfileV1(id: id))
    }

    enum Error: Swift.Error, CustomStringConvertible, Equatable {
        case bundleIdNotIncluded
        case certificatesNotIncluded
        case devicesNotIncluded
        case nothingToUpdate
        case profileNameNotProvided
        case profileTypeMissing
        case profileTypeUnsupported(type: String)

        var description: String {
            switch self {
            case .bundleIdNotIncluded:
                return "App Store Connect did not provide the bundle ID of the Provisioning Profile"
            case .certificatesNotIncluded:
                return "App Store Connect did not provide the certificates of the Provisioning Profile"
            case .devicesNotIncluded:
                return "App Store Connect did not provide the devices of the Provisioning Profile"
            case .nothingToUpdate:
                return "Nothing to update! Provide UDIDs to add and/or remove devices to/from the Provisioning Profile"
            case .profileNameNotProvided:
                return "App Store Connect did not provide the name of the Provisioning Profile"
            case .profileTypeMissing:
                return "Provisioning Profile is missing a profile type"
            case let .profileTypeUnsupported(type):
                return "Provisioning Profile has unsupported profile type '\(type)'"
            }
        }
    }
}
