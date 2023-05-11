// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models
import Bagbutik_TestFlight

struct ListPreReleaseVersionsCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "list",
        abstract: "Get a list of prerelease versions for all apps."
    )

    @OptionGroup()
    var common: CommonOptions

    @OptionGroup()
    var appLookupOptions: AppLookupOptions

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter by platform: \(Platform.allValueStringsFormatted)",
            valueName: "platform"
        )
    )
    var filterPlatforms: [Platform] = []

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter by version number. eg. 1.0.1",
            valueName: "version"
        )
    )
    var filterVersions: [String] = []

    @Option(
        parsing: .unconditional,
        help: ArgumentHelp(
            "Sort the results using one or more of: \(ListPreReleaseVersionsV1.Sort.allValueStringsFormatted).",
            discussion: "The `-` prefix indicates descending order."
        ),
        transform: { $0.components(separatedBy: ",").compactMap(ListPreReleaseVersionsV1.Sort.init(argument:)) }
    )
    var sorts: [ListPreReleaseVersionsV1.Sort]

    func run() async throws {
        let service = try makeService()

        var filterAppIds: [String] = []
        var filterBundleIds: [String] = []

        appLookupOptions.filterIdentifiers.forEach { identifier in
            switch identifier {
            case let .appId(filterAppId):
                filterAppIds.append(filterAppId)
            case let .bundleId(filterBundleId):
                filterBundleIds.append(filterBundleId)
            }
        }

        if filterBundleIds.isNotEmpty {
            filterAppIds += try await GetAppsOperation(
                service: service,
                options: .init(bundleIds: filterBundleIds)
            )
            .execute()
            .map(\.id)
        }

        try await ListPreReleaseVersionsOperation(
            service: service,
            options: .init(
                filterAppIds: filterAppIds,
                filterVersions: filterVersions,
                filterPlatforms: filterPlatforms,
                sorts: sorts
            )
        )
        .execute()
        .flatMap { try $0.preReleaseVersions() }
        .render(options: common.outputOptions)
    }
}

extension Platform: ExpressibleByArgument {
    public static var allValueStrings: [String] {
        allCases.map { $0.rawValue.lowercased() }
    }

    public init?(argument: String) {
        self.init(rawValue: argument.uppercased())
    }
}

extension ListPreReleaseVersionsV1.Sort: ExpressibleByArgument {}
