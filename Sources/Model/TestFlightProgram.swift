// Copyright 2023 Itty Bitty Apps Pty Ltd

/// Aggregated model data representing the a TestFlight Beta Program (Apps, Testers and Groups)
public struct TestFlightProgram {

    public var apps: [App]
    public var betaTesters: [BetaTester]
    public var betaGroups: [BetaGroup]

    public init(
        apps: [App],
        betaTesters: [BetaTester],
        betaGroups: [BetaGroup]
    ) {
        self.apps = apps
        self.betaTesters = betaTesters
        self.betaGroups = betaGroups
    }
}
