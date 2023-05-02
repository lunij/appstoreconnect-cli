// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct UpdateProfileCommand: CommonParsableCommand {

    static var configuration = CommandConfiguration(
        commandName: "update",
        abstract: "Updates an existing provisioning profile."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The id of the provisioning profile to update.")
    var id: String

    @Option(
        parsing: .upToNextOption,
        help: "The UDIDs of devices to be added to the provisioning profile. Required for development profiles only."
    )
    var udidsToAdd: [String] = []

    @Option(
        parsing: .upToNextOption,
        help: "The UDIDs of devices to be removed from the provisioning profile. Required for development profiles only."
    )
    var udidsToRemove: [String] = []

    func run() async throws {
        let service = try makeService()
        try await UpdateProfileUseCase(service: service).updateProfile(
            id: id,
            udidsToAdd: udidsToAdd,
            udidsToRemove: udidsToRemove,
            outputOptions: common.outputOptions
        )
    }
}
