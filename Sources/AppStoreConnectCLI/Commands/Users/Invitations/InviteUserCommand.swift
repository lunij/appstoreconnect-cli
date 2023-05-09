// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct InviteUserCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "invite",
        abstract: "Invite a user with assigned user roles to join your team."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(
        help: ArgumentHelp(
            "The email address of a pending user invitation.",
            discussion: "The email address must be valid to activate the account. It can be any email address, not necessarily one associated with an Apple ID."
        )
    )
    var email: String

    @Argument(help: "The user invitation recipient's first name.")
    var firstName: String

    @Argument(help: "The user invitation recipient's last name.")
    var lastName: String

    @OptionGroup()
    var userInfo: UserInfoArguments

    func validate() throws {
        if userInfo.allAppsVisible == false, userInfo.bundleIds.isEmpty {
            throw ValidationError("If you set allAppsVisible to false, you must provide at least one value for the visibleApps relationship.")
        }
    }

    public func run() async throws {
        let service = try makeService()
        let invitation: UserInvitation

        if userInfo.allAppsVisible {
            invitation = try await service.inviteUserToTeam(
                email: email,
                firstName: firstName,
                lastName: lastName,
                roles: userInfo.roles,
                allAppsVisible: userInfo.allAppsVisible,
                provisioningAllowed: userInfo.provisioningAllowed
            )
        } else {
            let resourceIds = try await service
                .appResourceIdsForBundleIds(userInfo.bundleIds)

            guard resourceIds.isEmpty == false else {
                throw Error.appNotFound(bundleIds: userInfo.bundleIds)
            }

            invitation = try await service.inviteUserToTeam(
                email: email,
                firstName: firstName,
                lastName: lastName,
                roles: userInfo.roles,
                allAppsVisible: userInfo.allAppsVisible,
                provisioningAllowed: userInfo.provisioningAllowed,
                appsVisibleIds: resourceIds
            )
        }

        try invitation.render(options: common.outputOptions)
    }

    enum Error: Swift.Error, CustomStringConvertible, Equatable {
        case appNotFound(bundleIds: [String])

        var description: String {
            switch self {
            case let .appNotFound(bundleIds):
                return "No apps were found matching \(bundleIds)."
            }
        }
    }
}

private extension BagbutikServiceProtocol {
    func inviteUserToTeam(
        email: String,
        firstName: String,
        lastName: String,
        roles: [UserRole],
        allAppsVisible: Bool,
        provisioningAllowed: Bool,
        appsVisibleIds: [String] = []
    ) async throws -> UserInvitation {
        // appsVisibleIds should be empty when allAppsVisible is true
        precondition(allAppsVisible && appsVisibleIds.isEmpty)

        let invitation = try await request(
            .createUserInvitationV1(
                requestBody: .init(
                    data: .init(
                        attributes: .init(
                            allAppsVisible: allAppsVisible,
                            email: email,
                            firstName: firstName,
                            lastName: lastName,
                            provisioningAllowed: provisioningAllowed,
                            roles: roles
                        )
                    )
                )
            )
        ).data

        return .init(invitation)
    }
}
