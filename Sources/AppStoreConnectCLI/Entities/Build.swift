// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Foundation
import SwiftyTextTable

struct Build: Codable, Equatable {
    let app: App?
    let platform: String?
    let version: String?
    let externalBuildState: String?
    let internalBuildState: String?
    let autoNotifyEnabled: String?
    let buildNumber: String?
    let processingState: String?
    let minOsVersion: String?
    let uploadedDate: String?
    let expirationDate: String?
    let expired: String?
    let usesNonExemptEncryption: String?
    let betaReviewState: String?
}

// MARK: - Extensions

extension Build {
    init(_ build: Bagbutik_Models.Build, _ includes: [Bagbutik_Models.BuildsResponse.Included]) throws {
        var app: Bagbutik_Models.App?
        var prereleaseVersion: Bagbutik_Models.PrereleaseVersion?
        var buildBetaDetail: Bagbutik_Models.BuildBetaDetail?
        var betaAppReviewSubmission: Bagbutik_Models.BetaAppReviewSubmission?

        for include in includes {
            switch include {
            case let .app(value):
                app = value
            case let .prereleaseVersion(value):
                prereleaseVersion = value
            case let .buildBetaDetail(value):
                buildBetaDetail = value
            case let .betaAppReviewSubmission(value):
                betaAppReviewSubmission = value
            default:
                break
            }
        }

        self.init(
            app: try app.map(App.init),
            platform: prereleaseVersion?.attributes?.platform?.rawValue,
            version: prereleaseVersion?.attributes?.version,
            externalBuildState: buildBetaDetail?.attributes?.externalBuildState?.rawValue,
            internalBuildState: buildBetaDetail?.attributes?.internalBuildState?.rawValue,
            autoNotifyEnabled: buildBetaDetail?.attributes?.autoNotifyEnabled?.yesNo,
            buildNumber: build.attributes?.version,
            processingState: build.attributes?.processingState?.rawValue,
            minOsVersion: build.attributes?.minOsVersion,
            uploadedDate: build.attributes?.uploadedDate?.formattedDate,
            expirationDate: build.attributes?.expirationDate?.formattedDate,
            expired: build.attributes?.expired?.yesNo,
            usesNonExemptEncryption: build.attributes?.usesNonExemptEncryption?.yesNo,
            betaReviewState: betaAppReviewSubmission?.attributes?.betaReviewState?.rawValue
        )
    }
}

extension Build: ResultRenderable {}

extension Build: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "Bundle Id"),
            TextTableColumn(header: "App Name"),
            TextTableColumn(header: "Platform"),
            TextTableColumn(header: "Version"),
            TextTableColumn(header: "Build Number"),
            TextTableColumn(header: "Beta Review state"),
            TextTableColumn(header: "Processing State"),
            TextTableColumn(header: "Internal build state"),
            TextTableColumn(header: "External build state"),
            TextTableColumn(header: "Auto Notify"),
            TextTableColumn(header: "Min OS Version"),
            TextTableColumn(header: "Uploaded Date"),
            TextTableColumn(header: "Expiration Date"),
            TextTableColumn(header: "Expired"),
            TextTableColumn(header: "Uses Non Exempt Encryption")
        ]
    }

    var tableRow: [CustomStringConvertible] {
        let row = [
            app?.bundleId,
            app?.name,
            platform,
            version,
            buildNumber,
            betaReviewState,
            processingState,
            internalBuildState,
            externalBuildState,
            autoNotifyEnabled,
            minOsVersion,
            uploadedDate,
            expirationDate,
            expired,
            usesNonExemptEncryption
        ]

        return row.map { $0 ?? "" }
    }
}
