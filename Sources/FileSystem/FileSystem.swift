// Copyright 2020 Itty Bitty Apps Pty Ltd

import Foundation
import Model

public func writeTestFlightConfiguration(program: TestFlightProgram, to folderPath: String) throws {
    let configuration = try TestFlightConfiguration(program: program)

    let processor = TestFlightConfigurationProcessor(path: folderPath)
    try processor.writeConfiguration(configuration)
}

public func readTestFlightConfiguration(from folderPath: String) throws -> TestFlightProgram {
    let processor = TestFlightConfigurationProcessor(path: folderPath)

    let config = try processor.readConfiguration()

    // TODO: Convert a TestFlightConfiguration into a TestFlightProgram

    return TestFlightProgram(apps: [], testers: [], groups: [])
}
