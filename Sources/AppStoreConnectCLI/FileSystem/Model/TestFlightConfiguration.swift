// Copyright 2023 Itty Bitty Apps Pty Ltd

import Foundation

struct TestFlightConfiguration {
    var appConfigurations: [AppConfiguration] = []

    init() {}

    init(appConfigurations: [AppConfiguration]) {
        self.appConfigurations = appConfigurations
    }

    init(program: TestFlightProgram) throws {
        let groupsByApp = Dictionary(grouping: program.groups, by: \.app?.id)
        let testers = program.testers

        appConfigurations = try program.apps.map { app in
            var config = AppConfiguration(app: app)

            config.betaTesters = try testers
                .filter { tester in tester.apps.map(\.id).contains(app.id) }
                .map(BetaTester2.init)

            config.betaGroups = (groupsByApp[app.id] ?? []).map { betaGroup in
                BetaGroup2(
                    betaGroup: betaGroup,
                    betaTesters: testers.filter { $0.betaGroups.map(\.id).contains(betaGroup.id) }
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
