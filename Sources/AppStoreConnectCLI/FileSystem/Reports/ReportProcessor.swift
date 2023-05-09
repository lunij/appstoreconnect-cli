// Copyright 2023 Itty Bitty Apps Pty Ltd

import Files
import Foundation

struct ReportProcessor {
    typealias Report = Data

    let path: String

    @discardableResult
    func write(_ report: Report) throws -> File {
        let standardizedPath = path as NSString
        return try Folder(path: standardizedPath.deletingLastPathComponent)
            .createFile(
                named: "\(standardizedPath.lastPathComponent).txt.gz",
                contents: report
            )
    }
}
