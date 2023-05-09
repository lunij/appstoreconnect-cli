// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct DeleteProfileCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "delete",
        abstract: "Delete a provisioning profile that is used for app development or distribution."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The UUID of the provisioning profile to delete.")
    var uuid: String

    func run() async throws {
        let service = try makeService()

        let profiles = try await service
            .request(.listProfilesV1())
            .data
            .filter { $0.attributes?.uuid == uuid }

        if profiles.count > 1 {
            throw Error.multipleProfilesFound(uuid)
        }

        guard let profile = profiles.first else {
            throw Error.profileNotFound(uuid)
        }

        try await service.request(.deleteProfileV1(id: profile.id))
    }

    enum Error: Swift.Error, CustomStringConvertible, Equatable {
        case profileNotFound(String)
        case multipleProfilesFound(String)

        var description: String {
            switch self {
            case let .profileNotFound(uuid):
                return "Profile with UUID \(uuid) not found"
            case let .multipleProfilesFound(uuid):
                return "Multiple profiles found for UUID \(uuid)"
            }
        }
    }
}
