// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik

struct CancelUserInvitationsCommand: CommonParsableCommand {
    public static var configuration = CommandConfiguration(
        commandName: "cancel-invitation",
        abstract: "Cancel a pending invitation for a user to join your team."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The email address of a pending user invitation.")
    var email: String

    public func run() async throws {
        let service = try makeService()
        let id = try await service.invitationIdentifier(matching: email)
        _ = try await service.request(.deleteUserInvitationV1(id: id))
    }

    enum Error: Swift.Error, CustomStringConvertible, Equatable {
        case userInvitationNotFound(email: String)

        var description: String {
            switch self {
            case let .userInvitationNotFound(email):
                return "User invitation with email address '\(email)' not found"
            }
        }
    }
}

private extension BagbutikService {
    /// Find the opaque internal identifier for this invitation; search by email address.
    ///
    /// This is an App Store Connect internal identifier
    func invitationIdentifier(matching email: String) async throws -> String {
        let invitations = try await request(.listUserInvitationsV1(filters: [.email([email])]))
            .data

        guard let invitation = invitations.first(where: { $0.attributes?.email == email }) else {
            throw CancelUserInvitationsCommand.Error.userInvitationNotFound(email: email)
        }

        return invitation.id
    }
}
