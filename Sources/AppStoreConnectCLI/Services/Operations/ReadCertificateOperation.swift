// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine
import Foundation

struct ReadCertificateOperation: APIOperation {
    struct Options {
        let serial: String
    }

    enum Error: LocalizedError {
        case couldNotFindCertificate(String)
        case serialNumberNotUnique(String)

        var errorDescription: String? {
            switch self {
            case let .couldNotFindCertificate(serial):
                return "Couldn't find certificate with serial '\(serial)'."
            case let .serialNumberNotUnique(serial):
                return "The serial number your provided '\(serial)' is not unique."
            }
        }
    }

    private var endpoint: APIEndpoint<CertificatesResponse> {
        APIEndpoint.listDownloadCertificates(
            filter: [.serialNumber([options.serial])]
        )
    }

    private let options: Options

    init(options: Options) {
        self.options = options
    }

    func execute(with requestor: EndpointRequestor) -> AnyPublisher<AppStoreConnect_Swift_SDK.Certificate, Swift.Error> {
        requestor.request(endpoint)
            .tryMap { [serial = options.serial] (response: CertificatesResponse) -> AppStoreConnect_Swift_SDK.Certificate in
                if response.data.count > 1 {
                    throw Error.serialNumberNotUnique(serial)
                }

                guard let certificate = response.data.first else {
                    throw Error.couldNotFindCertificate(serial)
                }

                return certificate
            }
            .eraseToAnyPublisher()
    }
}
