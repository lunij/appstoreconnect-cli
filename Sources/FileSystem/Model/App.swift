// Copyright 2023 Itty Bitty Apps Pty Ltd

import Foundation
import Model

struct App: Codable {
    var id: String
    var bundleId: String
    var name: String?
    var primaryLocale: String?
    var sku: String?

    init(model: Model.App) throws {
        guard let bundleId = model.bundleId else {
            throw ModelError.missingBundleId(appId: model.id)
        }

        id = model.id
        self.bundleId = bundleId
        name = model.name
        primaryLocale = model.primaryLocale
        sku = model.sku
    }
}
