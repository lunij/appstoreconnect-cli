// Copyright 2023 Itty Bitty Apps Pty Ltd

public struct BetaTester: Codable, Equatable {

    public var email: String?
    public var firstName: String?
    public var lastName: String?
    public var inviteType: String?
    public var betaGroups: [BetaGroup]?

    public init(
        email: String?,
        firstName: String?,
        lastName: String?,
        inviteType: String?,
        betaGroups: [BetaGroup]?
    ) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.inviteType = inviteType
        self.betaGroups = betaGroups
    }
}

extension BetaTester {
    public var apps: [App]? {
        betaGroups?.compactMap(\.app)
    }
}
