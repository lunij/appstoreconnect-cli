// Copyright 2023 Itty Bitty Apps Pty Ltd

import Foundation

func writeTestFlightConfiguration(program: TestFlightProgram, to folderPath: String) throws {
    let configuration = try TestFlightConfiguration(program: program)

    let processor = TestFlightConfigurationProcessor(path: folderPath)
    try processor.writeConfiguration(configuration)
}

func readTestFlightConfiguration(from folderPath: String) throws -> TestFlightProgram {
    let processor = TestFlightConfigurationProcessor(path: folderPath)

    let configuration = try processor.readConfiguration()

    return TestFlightProgram(configuration: configuration)
}
