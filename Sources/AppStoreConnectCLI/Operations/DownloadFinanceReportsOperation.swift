// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models

struct DownloadFinanceReportsOperation: APIOperation {
    struct Options {
        let regionCodes: [String]
        let reportDates: [String]
        let vendorNumbers: [String]
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> Gzip {
        try await service.request(.getFinanceReportsV1(
            filters: [
                .regionCode(options.regionCodes),
                .reportDate(options.reportDates),
                .vendorNumber(options.vendorNumbers)
            ]
        ))
    }
}
