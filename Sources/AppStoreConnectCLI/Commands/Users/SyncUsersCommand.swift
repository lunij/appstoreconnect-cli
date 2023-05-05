// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import ArgumentParser
import Combine
import FileSystem
import Foundation
import struct Model.User

struct SyncUsersCommand: CommonParsableCommand {
    typealias UserChange = CollectionDifference<User>.Change

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

    func run() throws {
        // Only print if the `PrintLevel` is set to verbose.
        if common.outputOptions.printLevel == .verbose {
            print("## Dry run ##")
        }

        let usersInFile = Readers.FileReader<[User]>(format: inputFormat).read(filePath: config)

        let client = try makeService()

        let change = try usersInAppStoreConnect(client)
            .flatMap { users -> AnyPublisher<UserChange, Error> in
                let changes = usersInFile.difference(from: users) { lhs, rhs -> Bool in
                    lhs.username == rhs.username
                }

                if self.dryRun {
                    return Publishers.Sequence(sequence: changes)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    return self.sync(users: changes, client: client)
                        .eraseToAnyPublisher()
                }
            }
            .await()

        Renderers.UserChangesRenderer(dryRun: dryRun).render(change)
    }

    private func sync(users changes: CollectionDifference<User>, client: AppStoreConnectService) -> AnyPublisher<UserChange, Error> {
        let requests = changes
            .compactMap { change -> AnyPublisher<UserChange, Error>? in
                switch change {
                case let .insert(_, user, _):
                    return client
                        .request(APIEndpoint.invite(user: user))
                        .map { _ in change }
                        .eraseToAnyPublisher()

                case let .remove(_, user, _):
                    let removeUser = { client.request(APIEndpoint.remove(userWithId: $0)) }

                    return client
                        .userIdentifier(matching: user.username)
                        .flatMap(removeUser)
                        .map { _ in change }
                        .eraseToAnyPublisher()
                }
            }

        return Publishers.ConcatenateMany(requests).eraseToAnyPublisher()
    }

    private func usersInAppStoreConnect(_ client: AppStoreConnectService) -> AnyPublisher<[User], Error> {
        client
            .request(.users())
            .map(User.fromAPIResponse)
            .eraseToAnyPublisher()
    }
}

private extension Renderers {
    struct UserChangesRenderer: Renderer {
        let dryRun: Bool

        func render(_ input: SyncUsersCommand.UserChange) {
            switch input {
            case let .insert(_, user, _):
                print("+\(user.username)")
            case let .remove(_, user, _):
                print("-\(user.username)")
            }
        }
    }
}
