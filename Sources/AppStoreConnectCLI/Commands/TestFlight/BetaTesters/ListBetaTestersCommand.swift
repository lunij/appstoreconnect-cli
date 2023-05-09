// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models
import Bagbutik_TestFlight

struct ListBetaTestersCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "list",
        abstract: "List beta testers"
    )

    @OptionGroup()
    var common: CommonOptions

    @Option(
        help: ArgumentHelp(
            "Beta tester's email.",
            valueName: "email"
        )
    )
    var filterEmail: String?

    @Option(
        help: ArgumentHelp(
            "Beta tester's first name.",
            valueName: "first-name"
        )
    )
    var filterFirstName: String?

    @Option(
        help: ArgumentHelp(
            "Beta tester's last name.",
            valueName: "last-name"
        )
    )
    var filterLastName: String?

    @Option(
        help: ArgumentHelp(
            """
            An invite type that indicates if a beta tester was invited by email or by hyperlink.
            Possible values: \(BetaInviteType.allValueStringsFormatted)
            """,
            valueName: "invite-type"
        )
    )
    var filterInviteType: BetaInviteType?

    @OptionGroup()
    var appLookupOptions: AppLookupOptions

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "TestFlight beta group names.",
            valueName: "group-name"
        )
    )
    var filterGroupNames: [String] = []

    @Option(help: "Number of resources to return. (maximum: 200)")
    var limit: Int?

    @Option(
        parsing: .unconditional,
        help: ArgumentHelp(
            "Sort the results using one or more of: \(ListBetaTestersV1.Sort.allValueStringsFormatted)",
            discussion: "The `-` prefix indicates descending order."
        ),
        transform: { $0.components(separatedBy: ",").compactMap(ListBetaTestersV1.Sort.init(argument:)) }
    )
    var sorts: [ListBetaTestersV1.Sort] = []

    @Option(help: "Number of included related resources to return.")
    var relatedResourcesLimit: Int?

    func validate() throws {
        if !appLookupOptions.filterIdentifiers.isEmpty, !filterGroupNames.isEmpty {
            throw ValidationError("Only one of these relationship filters ('app-id/ bundle-id', 'group-name') can be applied.")
        }
    }

    func run() async throws {
        let service = try makeService()
        let useCase = ListBetaTestersUseCase(service: service)

        try await useCase.listBetaTesters(
            email: filterEmail,
            firstName: filterFirstName,
            lastName: filterLastName,
            inviteType: filterInviteType,
            filterIdentifiers: appLookupOptions.filterIdentifiers,
            groupNames: filterGroupNames,
            sorts: sorts,
            limit: limit,
            relatedResourcesLimit: relatedResourcesLimit
        )
        .render(options: common.outputOptions)
    }
}

extension ListBetaTestersV1.Sort: ExpressibleByArgument {}
