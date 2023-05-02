// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import Model
import SwiftyTextTable

extension Model.BuildLocalization {
    init(_ localization: Bagbutik.BetaBuildLocalization) {
        self.init(
            locale: localization.attributes?.locale,
            whatsNew: localization.attributes?.whatsNew
        )
    }
}

extension Model.BuildLocalization: ResultRenderable, TableInfoProvider {

    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "Locale"),
            TextTableColumn(header: "What's New (truncated)"),
        ]
    }

    var tableRow: [CustomStringConvertible] {
        [
            locale ?? "",
            (whatsNew ?? "")
                .debugDescription
                .replacingOccurrences(of: "\\n", with: " ")
                .truncate(to: 100),
        ]
    }

}
