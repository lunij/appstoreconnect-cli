// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Bagbutik_Reporting

struct DownloadSalesOperation: APIOperation {
    typealias Filter = GetSalesReportsV1.Filter

    struct Options {
        let frequency: [Filter.Frequency]
        let reportType: [Filter.ReportType]
        let reportSubType: [Filter.ReportSubType]
        let vendorNumber: [String]
        let reportDate: [String]
        let version: [String]
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> Gzip {
        var filters: [Filter] = [
            .frequency(options.frequency),
            .reportDate(options.reportDate),
            .reportSubType(options.reportSubType),
            .vendorNumber(options.vendorNumber)
        ]

        if options.reportDate.isNotEmpty { filters.append(.reportType(options.reportType)) }
        if options.version.isNotEmpty { filters.append(.version(options.version)) }

        return try await service.request(.getSalesReportsV1(filters: filters))
    }
}
