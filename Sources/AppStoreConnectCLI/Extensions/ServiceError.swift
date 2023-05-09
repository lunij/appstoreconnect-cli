// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Core

extension ServiceError: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .badRequest(response),
             let .unauthorized(response),
             let .forbidden(response),
             let .notFound(response),
             let .conflict(response),
             let .unprocessableEntity(response):
            return response.errors?.first?.detail ?? "\(response)"
        case let .wrongDateFormat(dateString):
            return "A date in the response has an unknown format. The date: \(dateString)"
        case let .unknownHTTPError(statusCode, data):
            return "An unhandled HTTP error occurred. Status code \(statusCode). Data as UTF-8 string: \(String(data: data, encoding: .utf8) ?? "Not UTF-8")"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
