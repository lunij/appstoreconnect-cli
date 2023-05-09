// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
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
    init(_ build: AppStoreConnect_Swift_SDK.Build, _ includes: [AppStoreConnect_Swift_SDK.BuildRelationship]?) {
        let relationships = build.relationships

        let includedApps = includes?.compactMap { relationship -> AppStoreConnect_Swift_SDK.App? in
            if case let .app(app) = relationship {
                return app
            }
            return nil
        }

        let includedPrereleaseVersions = includes?.compactMap { relationship -> AppStoreConnect_Swift_SDK.PrereleaseVersion? in
            if case let .preReleaseVersion(prereleaseVersion) = relationship {
                return prereleaseVersion
            }
            return nil
        }

        let includedBuildBetaDetails = includes?.compactMap { relationship -> AppStoreConnect_Swift_SDK.BuildBetaDetail? in
            if case let .buildBetaDetail(buildBetaDetail) = relationship {
                return buildBetaDetail
            }
            return nil
        }

        let includedBetaAppReviewSubmissions = includes?.compactMap { relationship -> AppStoreConnect_Swift_SDK.BetaAppReviewSubmission? in
            if case let .betaAppReviewSubmission(betaAppReviewSubmission) = relationship {
                return betaAppReviewSubmission
            }
            return nil
        }

        let appDetails = includedApps?.first { relationships?.app?.data?.id == $0.id }
        let prereleaseVersion = includedPrereleaseVersions?.first { relationships?.preReleaseVersion?.data?.id == $0.id }
        let buildBetaDetail = includedBuildBetaDetails?.first { relationships?.buildBetaDetail?.data?.id == $0.id }
        let betaAppReviewSubmission = includedBetaAppReviewSubmissions?.first { relationships?.betaAppReviewSubmission?.data?.id == $0.id }

        let app = appDetails.map(App.init)

        self.init(
            app: app,
            platform: prereleaseVersion?.attributes?.platform?.rawValue,
            version: prereleaseVersion?.attributes?.version,
            externalBuildState: buildBetaDetail?.attributes?.externalBuildState?.rawValue,
            internalBuildState: buildBetaDetail?.attributes?.internalBuildState?.rawValue,
            autoNotifyEnabled: buildBetaDetail?.attributes?.autoNotifyEnabled?.yesNo,
            buildNumber: build.attributes?.version,
            processingState: build.attributes?.processingState,
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
