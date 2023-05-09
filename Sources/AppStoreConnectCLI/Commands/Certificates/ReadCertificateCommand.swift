// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct ReadCertificateCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "read",
        abstract: "Get information about a certificate and download the certificate data."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The certificate’s serial number (eg. 1A23BCDEF4G5D6C7)")
    var serial: String

    @Option(help: "The path the certificate is downloaded to (eg. ./file.cer)")
    var downloadPath: String?

    func run() async throws {
        let service = try makeService()
        let certificate = try await ReadCertificateOperation(
            service: service,
            options: .init(serial: serial)
        )
        .execute()

        if let path = downloadPath {
            let fileProcessor = CertificateProcessor(path: .file(path: path))
            let file = try fileProcessor.write(certificate)

            if common.outputOptions.printLevel == .verbose {
                print("📥 Certificate '\(certificate.name ?? "")' downloaded to: \(file.path)")
            }
        }

        try certificate.render(options: common.outputOptions)
    }
}
