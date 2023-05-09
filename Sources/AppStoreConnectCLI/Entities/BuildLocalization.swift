// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import SwiftyTextTable

struct BuildLocalization: Codable, Equatable {
    let locale: String?
    let whatsNew: String?
}

// MARK: - Extensions

extension BuildLocalization {
    init(_ localization: Bagbutik_Models.BetaBuildLocalization) {
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
