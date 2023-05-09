// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models

struct CreateCertificateCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "create",
        abstract: "Create a new certificate using a certificate signing request."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The type of certificate to create: \(CertificateType.allValueStringsFormatted)")
    var certificateType: CertificateType

    @Argument(help: "The Certificate Signing Request (CSR) file path.")
    var csrFile: String

    func run() async throws {
        let service = try makeService()
        let csrContent = try String(contentsOfFile: csrFile, encoding: .utf8)

        let certificate = try await CreateCertificateOperation(
            service: service,
            options: .init(certificateType: certificateType, csrContent: csrContent)
        )
        .execute()

        try Certificate(certificate).render(options: common.outputOptions)
    }
}
