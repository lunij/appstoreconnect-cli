// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import SwiftyTextTable

public struct BuildLocalization: Codable, Equatable {
    public let locale: String?
    public let whatsNew: String?

    public init(
        locale: String?,
        whatsNew: String?
    ) {
        self.locale = locale
        self.whatsNew = whatsNew
    }
}

// MARK: - Extensions

extension BuildLocalization {
    init(_ localization: AppStoreConnect_Swift_SDK.BetaBuildLocalization) {
        self.init(
            locale: localization.attributes?.locale,
            whatsNew: localization.attributes?.whatsNew
        )
    }
}

extension BuildLocalization: ResultRenderable {}

extension BuildLocalization: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "Locale"),
            TextTableColumn(header: "What's New (truncated)")
        ]
    }

    var tableRow: [CustomStringConvertible] {
        [
            locale ?? "",
            (whatsNew ?? "")
                .debugDescription
                .replacingOccurrences(of: "\\n", with: " ")
                .truncate(to: 100)
        ]
    }
}