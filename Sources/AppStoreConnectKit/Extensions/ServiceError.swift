// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

extension ServiceError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .badRequest(let response),
             .unauthorized(let response),
             .forbidden(let response),
             .notFound(let response),
             .conflict(let response):
            return response.errors?.first?.detail ?? "\(response)"
        case .wrongDateFormat(let dateString):
            return "A date in the response has an unknown format. The date: \(dateString)"
        case .unknownHTTPError(let statusCode, let data):
            return "An unhandled HTTP error occurred. Status code \(statusCode). Data as UTF-8 string: \(String(data: data, encoding: .utf8) ?? "Not UTF-8")"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
