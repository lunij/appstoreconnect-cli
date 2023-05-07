// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Foundation
import SwiftyTextTable

public struct Build: Codable, Equatable {
    public let app: App?
    public let platform: String?
    public let version: String?
    public let externalBuildState: String?
    public let internalBuildState: String?
    public let autoNotifyEnabled: String?
    public let buildNumber: String?
    public let processingState: String?
    public let minOsVersion: String?
    public let uploadedDate: String?
    public let expirationDate: String?
    public let expired: String?
    public let usesNonExemptEncryption: String?
    public let betaReviewState: String?

    public init(
        app: App?,
        platform: String?,
        version: String?,
        externalBuildState: String?,
        internalBuildState: String?,
        autoNotifyEnabled: String?,
        buildNumber: String?,
        processingState: String?,
        minOsVersion: String?,
        uploadedDate: String?,
        expirationDate: String?,
        expired: String?,
        usesNonExemptEncryption: String?,
        betaReviewState: String?
    ) {
        self.app = app
        self.platform = platform
        self.version = version
        self.externalBuildState = externalBuildState
        self.internalBuildState = internalBuildState
        self.autoNotifyEnabled = autoNotifyEnabled
        self.buildNumber = buildNumber
        self.processingState = processingState
        self.minOsVersion = minOsVersion
        self.uploadedDate = uploadedDate
        self.expirationDate = expirationDate
        self.expired = expired
        self.usesNonExemptEncryption = usesNonExemptEncryption
        self.betaReviewState = betaReviewState
    }
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
            autoNotifyEnabled: buildBetaDetail?.attributes?.autoNotifyEnabled?.toYesNo(),
            buildNumber: build.attributes?.version,
            processingState: build.attributes?.processingState,
            minOsVersion: build.attributes?.minOsVersion,
            uploadedDate: build.attributes?.uploadedDate?.formattedDate,
            expirationDate: build.attributes?.expirationDate?.formattedDate,
            expired: build.attributes?.expired?.toYesNo(),
            usesNonExemptEncryption: build.attributes?.usesNonExemptEncryption?.toYesNo(),
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
