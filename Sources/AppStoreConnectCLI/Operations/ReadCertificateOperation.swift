// Copyright 2023 Itty Bitty Apps Pty Ltd

struct ReadCertificateOperation: APIOperation {
    struct Options {
        let serial: String
    }

    enum Error: Swift.Error, CustomStringConvertible, Equatable {
        case certificateNotFound(String)
        case multipleCertificatesFound(String)

        var description: String {
            switch self {
            case let .certificateNotFound(serial):
                return "No certificate found with serial number \(serial)."
            case let .multipleCertificatesFound(serial):
                return "Multiple certificates found. The serial number \(serial) is not unique."
            }
        }
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> Certificate {
        let certificates = try await service
            .request(.listCertificatesV1Customized(filters: [.serialNumber([options.serial])]))
            .data

        if certificates.count > 1 {
            throw Error.multipleCertificatesFound(options.serial)
        }

        guard let certificate = certificates.first else {
            throw Error.certificateNotFound(options.serial)
        }

        return Certificate(certificate)
    }
}
