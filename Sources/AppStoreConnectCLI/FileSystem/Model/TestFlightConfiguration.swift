// Copyright 2023 Itty Bitty Apps Pty Ltd

import Foundation

struct TestFlightConfiguration {
    let appConfigurations: [AppConfiguration]

    init(appConfigurations: [AppConfiguration] = []) {
        self.appConfigurations = appConfigurations
    }

    init(program: TestFlightProgram) throws {
        let groupsByApp = Dictionary(grouping: program.betaGroups, by: \.app?.id)
        let testers = program.betaTesters

        appConfigurations = try program.apps.map { app in
            var config = AppConfiguration(app: app)

            config.betaTesters = try testers
                .filter { $0.apps?.contains { $0.id == app.id } ?? false }
                .map(BetaTester2.init)

            config.betaGroups = (groupsByApp[app.id] ?? []).map { betaGroup in
                BetaGroup2(
                    betaGroup: betaGroup,
                    betaTesters: testers.filter { $0.betaGroups?.contains { $0.id == betaGroup.id } ?? false }
                )
            }

            return config
        }
    }

    struct AppConfiguration {
        var app: App
        var betaTesters: [BetaTester2] = []
        var betaGroups: [BetaGroup2] = []
    }
}
