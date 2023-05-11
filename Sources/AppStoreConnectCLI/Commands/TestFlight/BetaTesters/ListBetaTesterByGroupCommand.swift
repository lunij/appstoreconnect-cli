// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct ListBetaTesterByGroupCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "listbygroup",
        abstract: "List beta testers in a specific beta group for a specific app"
    )

    @OptionGroup()
    var common: CommonOptions

    @OptionGroup()
    var appLookupArgument: AppLookupArgument

    @Argument(
        help: ArgumentHelp(
            "TestFlight beta group name.",
            discussion: "Please input a specific group name"
        )
    )
    var groupName: String

    func run() throws {
        let service = try makeService()

        let betaTesters = try service.listBetaTestersForGroup(identifier: appLookupArgument.identifier, groupName: groupName)
        try betaTesters.render(options: common.outputOptions)
    }
}
