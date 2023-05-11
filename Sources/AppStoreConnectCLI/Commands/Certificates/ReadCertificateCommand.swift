// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import FileSystem

struct ReadCertificateCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "read",
        abstract: "Get information about a certificate and download the certificate data."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The certificate’s serial number. (eg. 1A23BCDEF4G5D6C7)")
    var serial: String

    @Option(help: "The file download path and name. (eg. ./file.cer)")
    var certificateOutput: String?

    func run() throws {
        let service = try makeService()

        let certificate = try service
            .readCertificate(serial: serial)

        if let certificateOutput = certificateOutput {
            let fileProcessor = CertificateProcessor(path: .file(path: certificateOutput))

            let file = try fileProcessor.write(certificate)

            // Only print if the `PrintLevel` is set to verbose.
            if common.outputOptions.printLevel == .verbose {
                print("📥 Certificate '\(certificate.name ?? "")' downloaded to: \(file.path)")
            }
        }

        try certificate.render(options: common.outputOptions)
    }
}
