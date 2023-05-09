// Copyright 2023 Itty Bitty Apps Pty Ltd

import ArgumentParser

struct DownloadFinancialReportsCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "financial",
        abstract: "Download finance reports filtered by your specified criteria."
    )

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "You can download consolidated or separate financial reports per territory.")
    var regionCodes: [String]

    @Argument(help:
        ArgumentHelp(
            "The date of the report you wish to download based on the Apple Fiscal Calendar.",
            discussion: "The date is specified in the YYYY-MM format."
        )
    )
    var reportDate: String

    @Argument(help: "Your vendor number.")
    var vendorNumber: String

    @Argument(help: "The downloaded report file name.")
    var outputFilename: String

    func run() async throws {
        let service = try makeService()
        let data = try await DownloadFinanceReportsOperation(
            service: service,
            options: .init(
                regionCodes: regionCodes,
                reportDates: [reportDate],
                vendorNumbers: [vendorNumber]
            )
        )
        .execute()
        .data

        try ReportProcessor(path: outputFilename).write(data)
    }
}
