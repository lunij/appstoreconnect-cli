// Copyright 2023 Itty Bitty Apps Pty Ltd

import Files
import Foundation

public struct ReportProcessor {
    public typealias Report = Data

    let path: String

    public init(path: String) {
        self.path = path
    }

    @discardableResult
    public func write(_ report: Report) throws -> File {
        let standardizedPath = path as NSString
        return try Folder(path: standardizedPath.deletingLastPathComponent)
            .createFile(
                named: "\(standardizedPath.lastPathComponent).txt.gz",
                contents: report
            )
    }
}
