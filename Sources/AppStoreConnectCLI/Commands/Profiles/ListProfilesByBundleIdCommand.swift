// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct ListProfilesByBundleIdCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "list-by-bundle",
        abstract: "Find and list provisioning profiles by bundle identifier and download their data.",
        discussion: "Xcode managed profiles can be fetched with this command. Xcode managed profiles do not show up in the default profiles list."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(
        help: ArgumentHelp(
            "The bundle ID of an application. (eg. com.example.app)",
            discussion: "Note that all provisioning profiles for bundle identifiers beginning with this string will be fetched."
        )
    )
    var bundleId: String

    @Option(
        help: "Limit the number of profiles to return (maximum 200).",
        transform: { Int($0).map { min($0, 200) } }
    )
    var limit: Int?

    @Option(help:
        ArgumentHelp(
            "If set, the provisioning profiles will be saved as files to this path.",
            discussion: "Profiles will be saved to files with names of the pattern '<UUID>.\(ProfileProcessor.profileExtension)'.",
            valueName: "path"
        )
    )
    var downloadPath: String?

    func run() async throws {
        let service = try makeService()

        let bundleIdResourceIds = try await ListBundleIdsOperation(
            service: service,
            options: .init(identifiers: [bundleId], names: [], platforms: [], seedIds: [], limit: nil)
        )
        .execute()
        .filter { $0.attributes?.identifier?.starts(with: bundleId) ?? false }
        .map(\.id)

        let profiles = try await bundleIdResourceIds.asyncFlatMap {
            try await ListProfilesByBundleIdOperation(
                service: service,
                options: .init(bundleIdResourceId: $0, limit: limit)
            )
            .execute()
        }

        if let path = downloadPath {
            let processor = ProfileProcessor(path: .folder(path: path))

            try profiles.forEach {
                let file = try processor.write($0)

                print("📥 Profile '\($0.name ?? "")' downloaded to: \(file.path)")
            }
        }

        try profiles.render(options: common.outputOptions)
    }
}
