// Copyright 2023 Itty Bitty Apps Pty Ltd

import CodableCSV
import Files
import Foundation
import Yams

struct TestFlightConfigurationProcessor {
    let path: String

    private static let appYAMLName = "app.yml"
    private static let betaTestersCSVName = "beta-testers.csv"
    private static let betaGroupFolderName = "betagroups"

    func writeConfiguration(_ configuration: TestFlightConfiguration) throws {
        let appsFolder = try Folder(path: path)
        try appsFolder.delete()

        let rowsForTesters: ([BetaTester2]) -> [[String]] = { testers in
            let headers = [BetaTester2.CodingKeys.allCases.map(\.rawValue)]
            let rows = testers.map { [$0.email, $0.firstName, $0.lastName] }
            return headers + rows
        }

        let filenameForBetaGroup: (BetaGroup2) -> String = { betaGroup in
            betaGroup.groupName
                .components(separatedBy: CharacterSet(charactersIn: " *?:/\\."))
                .joined(separator: "_")
                + ".yml"
        }

        try configuration.appConfigurations.forEach { config in
            let bundleId = config.app.bundleId
            let appFolder = try appsFolder.createSubfolder(named: bundleId)

            let appFile = try appFolder.createFile(named: Self.appYAMLName)
            let appYAML = try YAMLEncoder().encode(config.app)
            try appFile.write(appYAML)

            let testersFile = try appFolder.createFile(named: Self.betaTestersCSVName)
            let testerRows = rowsForTesters(config.betaTesters)
            let testersCSV = try CSVWriter.encode(rows: testerRows, into: String.self)
            try testersFile.write(testersCSV)

            let groupFolder = try appFolder.createSubfolder(named: Self.betaGroupFolderName)
            let groupFiles: [(fileName: String, yamlData: String)] = try config.betaGroups.map {
                (filenameForBetaGroup($0), try YAMLEncoder().encode($0))
            }

            try groupFiles.forEach { file in
                try groupFolder.createFile(named: file.fileName).append(file.yamlData)
            }
        }
    }

    enum Error: LocalizedError {
        case testerNotInTestersList(email: String, betaGroup: BetaGroup2, app: App)

        var errorDescription: String? {
            switch self {
            case let .testerNotInTestersList(email, betaGroup, app):
                return "Tester with email: \(email) in beta group named: \(betaGroup.groupName) " +
                    "for app: \(app.bundleId) is not included in the \(betaTestersCSVName) file"
            }
        }
    }

    func readConfiguration() throws -> TestFlightConfiguration {
        let folder = try Folder(path: path)

        let decodeBetaTesters: (Data) throws -> [BetaTester2] = { data in
            var configuration = CSVReader.Configuration()
            configuration.headerStrategy = .firstLine

            let csv = try CSVReader.decode(input: data, configuration: configuration)

            return try csv.records.map { record in
                try BetaTester2(
                    email: record[BetaTester2.CodingKeys.email.rawValue],
                    firstName: record[BetaTester2.CodingKeys.firstName.rawValue],
                    lastName: record[BetaTester2.CodingKeys.lastName.rawValue]
                )
            }
        }

        let appConfigurations = try folder.subfolders.map { appFolder in
            let appYAML = try appFolder.file(named: Self.appYAMLName).readAsString()
            let app = try YAMLDecoder().decode(from: appYAML) as App

            var appConfiguration = TestFlightConfiguration.AppConfiguration(app: app)

            let testersFile = try appFolder.file(named: Self.betaTestersCSVName)
            let betaTesters = try decodeBetaTesters(try testersFile.read())
            appConfiguration.betaTesters = betaTesters

            let groupsFolder = try appFolder.subfolder(named: Self.betaGroupFolderName)
            let emails = betaTesters.map(\.email)
            appConfiguration.betaGroups = try groupsFolder.files.map { groupFile in
                let group: BetaGroup2 = try YAMLDecoder().decode(from: try groupFile.readAsString())

                if let email = group.testers.first(where: { !emails.contains($0) }) {
                    throw Error.testerNotInTestersList(email: email, betaGroup: group, app: app)
                }

                return group
            }

            return appConfiguration
        }

        return TestFlightConfiguration(appConfigurations: appConfigurations)
    }
}
