// Copyright 2023 Itty Bitty Apps Pty Ltd

import Foundation

/// Aggregated model data representing the a TestFlight Beta Program (Apps, Testers and Groups)
struct TestFlightProgram {
    var apps: [App]
    var betaGroups: [BetaGroup]
    var betaTesters: [BetaTester]
}

extension TestFlightProgram {
    init(configuration: TestFlightConfiguration) {
        var apps: [App] = []
        var testers: [String: BetaTester] = [:]
        var groups: [BetaGroup] = []

        for appConfiguration in configuration.appConfigurations {
            let app = App(app: appConfiguration.app)
            apps.append(app)

            let betaGroupModel = { BetaGroup(app: app, betaGroup: $0) }
            groups += appConfiguration.betaGroups.map(betaGroupModel)

            for betaTester in appConfiguration.betaTesters {
                var tester = testers[betaTester.email] ?? BetaTester(betaTester: betaTester)
                tester.betaGroups = appConfiguration
                    .betaGroups
                    .filter { $0.testers.contains(betaTester.email) }
                    .map(betaGroupModel)
                testers[betaTester.email] = tester
            }
        }

        self.init(
            apps: apps,
            betaGroups: groups,
            betaTesters: Array(testers.values)
        )
    }
}

private extension App {
    init(app: App) {
        self.init(
            id: app.id,
            bundleId: app.bundleId,
            name: app.name,
            primaryLocale: app.primaryLocale,
            sku: app.sku
        )
    }
}

private extension BetaTester {
    init(betaTester: BetaTester2) {
        self.init(
            email: betaTester.email,
            firstName: betaTester.firstName,
            lastName: betaTester.lastName,
            inviteType: nil,
            betaGroups: nil
        )
    }
}

private extension BetaGroup {
    init(app: App, betaGroup: BetaGroup2) {
        self.init(
            id: betaGroup.id,
            app: app,
            groupName: betaGroup.groupName,
            isInternal: nil,
            publicLink: nil,
            publicLinkEnabled: nil,
            publicLinkLimit: nil,
            publicLinkLimitEnabled: nil,
            creationDate: nil
        )
    }
}
