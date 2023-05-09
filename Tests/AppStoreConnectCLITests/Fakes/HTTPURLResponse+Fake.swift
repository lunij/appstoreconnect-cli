// Copyright 2023 Itty Bitty Apps Pty Ltd

import Foundation

extension HTTPURLResponse {
    static func fake(
        url: URL = .fakeWebURL,
        statusCode: Int = 200,
        httpVersion: String? = nil,
        headerFields: [String: String]? = nil
    ) -> HTTPURLResponse {
        .init(
            url: url,
            statusCode: statusCode,
            httpVersion: httpVersion,
            headerFields: headerFields
        )!
    }
}
