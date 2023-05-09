// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct ListBuildsCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "list",
        abstract: "Find and list builds for all apps in App Store Connect."
    )

    @OptionGroup()
    var common: CommonOptions

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter by app bundle identifier. eg. com.example.App",
            valueName: "bundle-id"
        )
    )
    var filterBundleIds: [String] = []

    @Flag(
        inversion: .prefixedNo,
        exclusivity: .exclusive,
        help: ArgumentHelp(
            "Whether expired builds should be included."
        )
    )
    var includeExpired = true

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter by the pre-release version number of a build",
            valueName: "pre-release-version"
        )
    )
    var filterPreReleaseVersions: [String] = []

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter by the build number of a build",
            valueName: "build-number"
        )
    )
    var filterBuildNumbers: [String] = []

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter by the processing state of a build: \(BuildProcessingState.allValueStringsFormatted)",
            valueName: "processing-state"
        )
    )
    var filterProcessingStates: [BuildProcessingState] = []

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter by the beta review state of a build: \(BetaReviewState.allValueStringsFormatted)",
            valueName: "beta-review-state"
        )
    )
    var filterBetaReviewStates: [BetaReviewState] = []

    @Option(help: "Limit the number of individualTesters & betaBuildLocalizations")
    var limit: Int?

    func run() async throws {
        let service = try makeService()
        var filterAppIds: [String] = []

        if filterBundleIds.isNotEmpty {
            filterAppIds = try await GetAppsOperation(
                service: service,
                options: .init(bundleIds: filterBundleIds)
            )
            .execute()
            .map(\.id)
        }

        try await ListBuildsOperation(
            service: service,
            options: .init(
                filterAppIds: filterAppIds,
                filterExpired: includeExpired ? [] : ["false"],
                filterPreReleaseVersions: filterPreReleaseVersions,
                filterBuildNumbers: filterBuildNumbers,
                filterProcessingStates: filterProcessingStates,
                filterBetaReviewStates: filterBetaReviewStates,
                limit: limit
            )
        )
        .execute()
        .map(Build.init)
        .render(options: common.outputOptions)
    }
}
