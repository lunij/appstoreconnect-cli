// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct AddGroupsToBuildCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "addbetagroup",
        abstract: "Add access for beta groups to a build"
    )

    @OptionGroup()
    var common: CommonOptions

    @OptionGroup()
    var build: BuildArguments

    @Argument(help: "Names of beta groups.")
    var groupNames: [String]

    func validate() throws {
        if groupNames.isEmpty {
            throw ValidationError("Excepted at least one group name.")
        }
    }

    func run() async throws {
        let service = try makeService()

        let (buildId, groupIds) = try await service.buildIdAndGroupIdsFrom(
            bundleId: build.bundleId,
            version: build.preReleaseVersion,
            buildNumber: build.buildNumber,
            groupNames: groupNames
        )

        try await AddGroupsToBuildOperation(
            service: service,
            options: .init(groupIds: groupIds, buildId: buildId)
        )
        .execute()
    }
}
