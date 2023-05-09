// Copyright 2023 Itty Bitty Apps Pty Ltd

import Foundation

struct TestFlightProgramDifference {
    enum Change {
        case addBetaGroup(BetaGroup)
        case removeBetaGroup(BetaGroup)
        case addBetaTesterToApps(BetaTester, [App])
        case removeBetaTesterFromApps(BetaTester, [App])
        case addBetaTesterToGroups(BetaTester, [BetaGroup])
        case removeBetaTesterFromGroups(BetaTester, [BetaGroup])

        var description: String {
            let operation: String = {
                switch self {
                case .addBetaGroup, .addBetaTesterToGroups, .addBetaTesterToApps:
                    return "added to"
                case .removeBetaGroup, .removeBetaTesterFromGroups, .removeBetaTesterFromApps:
                    return "removed from"
                }
            }()

            switch self {
            case let .addBetaGroup(betaGroup), let .removeBetaGroup(betaGroup):
                let name = betaGroup.groupName ?? ""
                let bundleId = betaGroup.app?.bundleId ?? ""

                return "Beta Group named: \(name) will be \(operation) app: \(bundleId)"

            case let .addBetaTesterToApps(betaTester, apps),
                 let .removeBetaTesterFromApps(betaTester, apps):
                let email = betaTester.email ?? ""
                let bundleIds = apps.map(\.bundleId).joined(separator: ", ")

                return "Beta Tester with email: \(email) " +
                    "will be \(operation) apps: \(bundleIds)"

            case let .addBetaTesterToGroups(betaTester, betaGroups),
                 let .removeBetaTesterFromGroups(betaTester, betaGroups):
                let email = betaTester.email ?? ""
                let groupNames = betaGroups.compactMap(\.groupName).joined(separator: ", ")
                let bundleIds = betaGroups.compactMap(\.app?.bundleId).joined(separator: ", ")

                return "Beta Tester with email: \(email) " +
                    "will be \(operation) groups: \(groupNames) " +
                    "in apps: \(bundleIds)"
            }
        }
    }

    let changes: [Change]

    init(local: TestFlightProgram, remote: TestFlightProgram) {
        var changes: [Change] = []

        // Groups
        let localGroups = local.groups
        let groupsToAdd: [BetaGroup] = localGroups.filter { $0.id == nil }
        changes += groupsToAdd.map(Change.addBetaGroup)

        let localGroupIds = localGroups.map(\.id)
        let groupsToRemove: [BetaGroup] = remote.groups
            .filter { group in localGroupIds.contains(group.id) == false }
        changes += groupsToRemove.map(Change.removeBetaGroup)

        // Testers
        let newTesters = local.testers.filter { !remote.testers.map(\.email).contains($0.email) }

        changes += newTesters.map { betaTester -> Change in
            betaTester.betaGroups.isEmpty
                ? .addBetaTesterToApps(betaTester, betaTester.apps)
                : .addBetaTesterToGroups(betaTester, betaTester.betaGroups)
        }

        for remoteTester in remote.testers {
            let remoteApps = remoteTester.apps
            let remoteBetaGroups = remoteTester.betaGroups

            if let localTester = local.testers.first(where: { $0.email == remoteTester.email }) {
                let appsToAdd = localTester.apps.filter { app in
                    let appIds = remoteApps.map(\.id) + remoteBetaGroups.compactMap(\.app?.id)
                    return appIds.contains(app.id) == false
                }
                let addToApps = Change.addBetaTesterToApps(remoteTester, appsToAdd)
                changes += appsToAdd.isNotEmpty ? [addToApps] : []

                let groupsToAdd = localTester.betaGroups
                    .filter { !remoteBetaGroups.map(\.id).contains($0.id) }
                let addToGroups = Change.addBetaTesterToGroups(remoteTester, groupsToAdd)
                changes += groupsToAdd.isNotEmpty ? [addToGroups] : []

                let appsToRemove = remoteApps.filter { app in
                    let appIds = localTester.apps.map(\.id) + localTester.betaGroups.compactMap(\.app?.id)
                    return appIds.contains(app.id) == false
                }
                let removeFromApps = Change.removeBetaTesterFromApps(remoteTester, appsToRemove)
                changes += appsToRemove.isNotEmpty ? [removeFromApps] : []

                let groupsToRemove = remoteBetaGroups
                    .filter { !localTester.betaGroups.map(\.id).contains($0.id) }
                let removeFromGroups = Change.removeBetaTesterFromGroups(remoteTester, groupsToRemove)
                changes += groupsToRemove.isNotEmpty ? [removeFromGroups] : []
            } else if remoteApps.isNotEmpty {
                changes.append(.removeBetaTesterFromApps(remoteTester, remoteApps))
            }
        }

        self.changes = changes
    }
}
