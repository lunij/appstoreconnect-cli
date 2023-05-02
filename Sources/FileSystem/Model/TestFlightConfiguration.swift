// Copyright 2023 Itty Bitty Apps Pty Ltd

import Model

struct TestFlightConfiguration {
    var appConfigurations: [AppConfiguration]

    init(appConfigurations: [AppConfiguration] = []) {
        self.appConfigurations = appConfigurations
    }

    init(program: TestFlightProgram) throws {
        let groupsByApp = Dictionary(grouping: program.betaGroups, by: \.app?.id)
        let testers = program.betaTesters

        appConfigurations = try program.apps.map { app in
            var config = try AppConfiguration(app: App(model: app))

            config.betaTesters = try testers
                .filter { $0.apps?.contains { $0.id == app.id } ?? false }
                .map(FileSystem.BetaTester.init)

            config.betaGroups = (groupsByApp[app.id] ?? []).map { betaGroup in
                FileSystem.BetaGroup(
                    betaGroup: betaGroup,
                    betaTesters: testers.filter { $0.betaGroups?.contains { $0.id == betaGroup.id } ?? false }
                )
            }

            return config
        }
    }

    struct AppConfiguration {
        var app: App
        var betaTesters: [BetaTester] = []
        var betaGroups: [BetaGroup] = []
    }
}
