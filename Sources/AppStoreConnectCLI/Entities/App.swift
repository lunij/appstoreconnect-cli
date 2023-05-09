// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine
import Foundation
import SwiftyTextTable

struct App: Codable, Equatable {
    let id: String
    var bundleId: String
    var name: String?
    var primaryLocale: String?
    var sku: String?

    enum Error: Swift.Error, CustomStringConvertible, Equatable {
        case bundleIdMissing(id: String)

        var description: String {
            switch self {
            case let .bundleIdMissing(id):
                return "The app with the id '\(id)' is missing the bundle identifier"
            }
        }
    }
}

// MARK: - Extensions

extension App {
    init(_ apiApp: AppStoreConnect_Swift_SDK.App) throws {
        let attributes = apiApp.attributes

        guard let bundleId = attributes?.bundleId else {
            throw Error.bundleIdMissing(id: apiApp.id)
        }

        self.init(
            id: apiApp.id,
            bundleId: bundleId,
            name: attributes?.name,
            primaryLocale: attributes?.primaryLocale,
            sku: attributes?.sku
        )
    }
}

extension App: ResultRenderable {}

extension App: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "App ID"),
            TextTableColumn(header: "App Bundle ID"),
            TextTableColumn(header: "Name"),
            TextTableColumn(header: "Primary Locale"),
            TextTableColumn(header: "SKU")
        ]
    }

    var tableRow: [CustomStringConvertible] {
        [
            id,
            bundleId,
            name ?? "",
            primaryLocale ?? "",
            sku ?? ""
        ]
    }
}

extension AppStoreConnectService {
    private enum AppError: LocalizedError {
        case couldntFindApp(bundleId: [String])

        var errorDescription: String? {
            switch self {
            case let .couldntFindApp(bundleIds):
                return "No apps were found matching \(bundleIds)."
            }
        }
    }

    /// Find the opaque internal identifier for an application that related to this bundle ID.
    func getAppResourceIdsFrom(bundleIds: [String]) -> AnyPublisher<[String], Error> {
        let getAppResourceIdRequest = APIEndpoint.apps(
            filters: [ListApps.Filter.bundleId(bundleIds)]
        )

        return request(getAppResourceIdRequest)
            .tryMap { (response: AppsResponse) throws -> [AppStoreConnect_Swift_SDK.App] in
                guard !response.data.isEmpty else {
                    throw AppError.couldntFindApp(bundleId: bundleIds)
                }

                return response.data
            }
            .compactMap { $0.map(\.id) }
            .eraseToAnyPublisher()
    }
}
