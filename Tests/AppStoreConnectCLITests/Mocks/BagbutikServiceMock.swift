// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Core
@testable import AppStoreConnectCLI

final class BagbutikServiceMock: BagbutikServiceProtocol {
    enum Call: Equatable {
        case request(path: String)
        case requestEmptyResponse(path: String)
        case requestAllPages(path: String)
    }

    var calls: [Call] = []

    var requestError: Error?
    var requestReturnValue: Any?
    func request<T>(_ request: Request<T, ErrorResponse>) async throws -> T where T: Decodable {
        calls.append(.request(path: request.path))

        if let value = requestReturnValue as? T {
            return value
        }

        throw requestError ?? FakeError()
    }

    var requestEmptyResponseError: Error?
    func request(_ request: Request<EmptyResponse, ErrorResponse>) async throws -> EmptyResponse {
        calls.append(.requestEmptyResponse(path: request.path))

        if let requestEmptyResponseError {
            throw requestEmptyResponseError
        }

        return EmptyResponse()
    }

    var requestAllPagesError: Error?
    var requestAllPagesResponses: [Any]?
    func requestAllPages<T>(_ request: Request<T, ErrorResponse>) async throws -> (responses: [T], data: [T.Data]) where T: PagedResponse, T: Decodable {
        calls.append(.requestAllPages(path: request.path))

        if let responses = requestAllPagesResponses as? [T] {
            return (responses, responses.flatMap(\.data))
        }

        throw requestAllPagesError ?? FakeError()
    }
}
