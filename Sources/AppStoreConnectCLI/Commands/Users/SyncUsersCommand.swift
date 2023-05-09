// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Core
import Bagbutik_Models

private typealias UserChange = CollectionDifference<User>.Change

struct SyncUsersCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "sync",
        abstract: "Sync information about users on your team with provided configuration file."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "Path to the file containing the information about users. Specify format with --input-format")
    var config: String

    @Option(help: "Read config file in provided format (\(InputFormat.allCases.map(\.rawValue).joined(separator: ", "))).")
    var inputFormat: InputFormat = .json

    @Flag(help: "Perform a dry run.")
    var dryRun = false

    func run() async throws {
        if common.outputOptions.printLevel == .verbose {
            print("## Dry run ##")
        }

        let usersInFile = Readers.FileReader<[User]>(format: inputFormat).read(filePath: config)

        let service = try makeService()

        let users = try await service.usersInAppStoreConnect()

        let changes = usersInFile.difference(from: users) { lhs, rhs -> Bool in
            lhs.username == rhs.username
        }

        if !dryRun {
            try await service.sync(changes: changes)
        }

        Renderers.UserChangesRenderer(dryRun: dryRun).render(changes)
    }
}

private extension Renderers {
    struct UserChangesRenderer: Renderer {
        let dryRun: Bool

        func render(_ input: CollectionDifference<User>) {
            for change in input {
                switch change {
                case let .insert(_, user, _):
                    print("+\(user.username)")
                case let .remove(_, user, _):
                    print("-\(user.username)")
                }
            }
        }
    }
}

extension Request<UserInvitationResponse, ErrorResponse> {
    static func invite(user: User) -> Self {
        .createUserInvitationV1(requestBody: .init(data: .init(
            attributes: .init(
                allAppsVisible: user.allAppsVisible,
                email: user.username,
                firstName: user.firstName,
                lastName: user.lastName,
                provisioningAllowed: user.provisioningAllowed,
                roles: user.roles.compactMap(UserRole.init(rawValue:))
            ),
            relationships: .init(visibleApps: .init(data: user.allAppsVisible ? [] : user.visibleApps?.map { .init(id: $0) }))
        )))
    }
}

private extension BagbutikServiceProtocol {
    func usersInAppStoreConnect() async throws -> [User] {
        let response = try await request(.listUsersV1())
        return User.fromAPIResponse(response)
    }

    func sync(changes: CollectionDifference<User>) async throws {
        for change in changes {
            switch change {
            case let .insert(_, user, _):
                _ = try await request(.invite(user: user))
            case let .remove(_, user, _):
                let userId = try await userIdentifier(matching: user.username)
                try await request(.deleteUserV1(id: userId))
            }
        }
    }

    /// Find the opaque internal identifier for this user; search by email address.
    ///
    /// This is an App Store Connect internal identifier
    func userIdentifier(matching email: String) async throws -> String {
        let users = try await request(.listUsersV1(filters: [.username([email])]))
            .data
            .filter { $0.attributes?.username == email }

        guard let user = users.first else {
            fatalError("User with email address '\(email)' not unique or not found")
        }

        return user.id
    }
}
