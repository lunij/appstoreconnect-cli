// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import Model
import SwiftyTextTable

extension Model.Build {
    init(_ build: Bagbutik.Build, _ includes: [Bagbutik.BuildsResponse.Included]) {
        var app: Bagbutik.App?
        var prereleaseVersion: Bagbutik.PrereleaseVersion?
        var buildBetaDetail: Bagbutik.BuildBetaDetail?
        var betaAppReviewSubmission: Bagbutik.BetaAppReviewSubmission?

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
            app: app.map(Model.App.init),
            platform: prereleaseVersion?.attributes?.platform?.rawValue,
            version: prereleaseVersion?.attributes?.version,
            externalBuildState: buildBetaDetail?.attributes?.externalBuildState?.rawValue,
            internalBuildState: buildBetaDetail?.attributes?.internalBuildState?.rawValue,
            autoNotifyEnabled: buildBetaDetail?.attributes?.autoNotifyEnabled?.toYesNo(),
            buildNumber: build.attributes?.version,
            processingState: build.attributes?.processingState?.rawValue,
            minOsVersion: build.attributes?.minOsVersion,
            uploadedDate: build.attributes?.uploadedDate?.formattedDate,
            expirationDate: build.attributes?.expirationDate?.formattedDate,
            expired: build.attributes?.expired?.toYesNo(),
            usesNonExemptEncryption: build.attributes?.usesNonExemptEncryption?.toYesNo(),
            betaReviewState: betaAppReviewSubmission?.attributes?.betaReviewState?.rawValue
        )
    }
}

extension Model.Build: ResultRenderable, TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        return [
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
            TextTableColumn(header: "Uses Non Exempt Encryption"),
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
            usesNonExemptEncryption,
        ]

        return row.map { $0 ?? ""}
    }
}
