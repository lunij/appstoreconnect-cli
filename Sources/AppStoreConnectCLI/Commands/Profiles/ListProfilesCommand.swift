// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Provisioning

struct ListProfilesCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "list",
        abstract: "Find and list provisioning profiles and download their data."
    )

    @OptionGroup()
    var common: CommonOptions

    @Option(help: "Limit the number of profiles to return (maximum 200).")
    var limit: Int?

    @Option(
        parsing: .unconditional,
        help: ArgumentHelp(
            "Sort the results using one or more of the following values: \(ListProfilesV1.Sort.allValueStringsFormatted).",
            discussion: "The `-` prefix indicates descending order."
        ),
        transform: { $0.components(separatedBy: ",").compactMap(ListProfilesV1.Sort.init(argument:)) }
    )
    var sorts: [ListProfilesV1.Sort] = []

    @Option(
        parsing: .upToNextOption,
        help: "The resource id of the profile."
    )
    var filterId: [String] = []

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter the results by the specified profile name.",
            valueName: "name"
        )
    )
    var filterName: [String] = []

    @Option(
        help: ArgumentHelp(
            "Filter the results by profile state: \(ProfileState.allValueStringsFormatted).",
            valueName: "state"
        )
    )
    var filterProfileState: ProfileState?

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter the results by profile types: \(ProfileType.allValueStringsFormatted)",
            valueName: "type"
        )
    )
    var filterProfileTypes: [ProfileType] = []

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
        let profiles = try await ListProfilesOperation(
            service: service,
            options: .init(
                ids: filterId,
                filterName: filterName,
                filterProfileState: filterProfileState,
                filterProfileTypes: filterProfileTypes,
                sorts: sorts,
                limit: limit
            )
        )
        .execute()

        if let path = downloadPath {
            let processor = ProfileProcessor(path: .folder(path: path))

            for profile in profiles {
                let file = try processor.write(profile)

                if common.outputOptions.printLevel == .verbose {
                    print("📥 Profile '\(profile.name ?? "")' downloaded to: \(file.path)")
                }
            }
        }

        try profiles.render(options: common.outputOptions)
    }
}

extension ListProfilesV1.Sort: ExpressibleByArgument {}
