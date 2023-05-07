// Copyright 2023 Itty Bitty Apps Pty Ltd

import Foundation

struct BetaGroup2: Codable, Equatable {
    typealias EmailAddress = String

    var id: String?
    var groupName: String
    var testers: [EmailAddress]

    init(betaGroup: BetaGroup, betaTesters: [BetaTester]) {
        id = betaGroup.id
        groupName = betaGroup.groupName ?? ""
        testers = betaTesters.compactMap(\.email)
    }
}
