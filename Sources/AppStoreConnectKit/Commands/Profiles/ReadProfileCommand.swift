// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct ReadProfileCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "read",
        abstract: "Find and read a provisioning profile and download its data."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The resource id of the provisioning profile to read.")
    var id: String

    @Option(
        help: ArgumentHelp(
            "If set, the provisioning profile will be saved as file to this path.",
            valueName: "path"
        )
    )
    var downloadPath: String?

    func run() async throws {
        let service = try makeService()
        try await ReadProfileUseCase(service: service).readProfile(
            id: id,
            downloadPath: downloadPath,
            outputOptions: common.outputOptions
        )
    }
}
