// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct RevokeCertificatesCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "revoke",
        abstract: "Revoke lost, stolen, compromised, or expiring signing certificates."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The certificates' serial numbers. (eg. 1A23BCDEF4G5D6C7)")
    var serials: [String]

    func validate() throws {
        if serials.isEmpty {
            throw ValidationError("Invalid input, you must provide at least one certificate serial number")
        }
    }

    func run() async throws {
        let service = try makeService()

        let certificatesIds = try await serials.asyncMap {
            try await ReadCertificateOperation(
                service: service,
                options: .init(serial: $0)
            )
            .execute()
            .id
        }

        _ = try await RevokeCertificatesOperation(
            service: service,
            options: .init(ids: certificatesIds)
        )
        .execute()

        // Only print if the `PrintLevel` is set to verbose.
        if common.outputOptions.printLevel == .verbose {
            serials.forEach {
                print("🚮 Certificate `\($0)` revoked.")
            }
        }
    }
}
