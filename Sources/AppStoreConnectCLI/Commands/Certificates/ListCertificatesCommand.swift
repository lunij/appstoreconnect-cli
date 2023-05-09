// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser
import Bagbutik_Models
import Bagbutik_Provisioning

struct ListCertificatesCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "list",
        abstract: "Find and list certificates and download their data."
    )

    @OptionGroup()
    var common: CommonOptions

    @Option(help: "The certificate’s serial number. (eg. 1A23BCDEF4G5D6C7)")
    var filterSerial: String?

    @Option(
        parsing: .unconditional,
        help: ArgumentHelp(
            "Sort the results using one or more of the following values: \(ListCertificatesV1.Sort.allValueStringsFormatted)",
            discussion: "The `-` prefix indicates descending order."
        ),
        transform: { $0.components(separatedBy: ",").compactMap(ListCertificatesV1.Sort.init(argument:)) }
    )
    var sorts: [ListCertificatesV1.Sort] = []

    @Option(help: "The type of certificate to create. Values: \(CertificateType.allValueStringsFormatted)")
    var filterType: CertificateType?

    @Option(help: "The certificate’s display name. (eg. Mac Installer Distribution: TeamName)")
    var filterDisplayName: String?

    @Option(help: "Limit the number of resources (maximum 200).")
    var limit: Int?

    @Option(help: "The directory path the certificates will be downloaded to (eg. ~/Documents)")
    var downloadPath: String?

    func run() async throws {
        let service = try makeService()
        let certificates = try await ListCertificatesOperation(
            service: service,
            options: .init(
                filterSerial: filterSerial,
                sorts: sorts.nilIfEmpty,
                filterType: filterType,
                filterDisplayName: filterDisplayName,
                limit: limit
            )
        )
        .execute()

        if let path = downloadPath {
            let certificateProcessor = CertificateProcessor(path: .folder(path: path))
            for certificate in certificates {
                let file = try certificateProcessor.write(certificate)

                if common.outputOptions.printLevel == .verbose {
                    print("📥 Certificate '\(certificate.name ?? "")' downloaded to: \(file.path)")
                }
            }
        }

        try certificates.render(options: common.outputOptions)
    }
}

extension ListCertificatesV1.Sort: ExpressibleByArgument {
    public static var allValueStrings: [String] {
        [
            Self.certificateTypeAscending.rawValue,
            Self.certificateTypeDescending.rawValue,
            Self.displayNameAscending.rawValue,
            Self.displayNameDescending.rawValue,
            Self.idAscending.rawValue,
            Self.idDescending.rawValue,
            Self.serialNumberAscending.rawValue,
            Self.serialNumberDescending.rawValue
        ]
    }
}
