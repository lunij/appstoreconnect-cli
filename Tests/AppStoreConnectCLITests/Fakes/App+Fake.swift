// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models

extension App {
    static func fake(
        id: String = "fakeId",
        name: String? = "fakeName",
        bundleId: String? = "fakeBundleId"
    ) -> Self {
        .init(
            id: id,
            links: .init(self: "fakeLink"),
            attributes: .init(
                bundleId: bundleId,
                name: name
            ),
            relationships: nil
        )
    }
}
