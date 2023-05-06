// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import CodableCSV
import Combine
import Foundation
import SwiftyTextTable
import Yams

protocol Renderer {
    associatedtype Input

    func render(_ input: Input) throws
}

enum Renderers {
    struct ResultRendererWithOptions<T: ResultRenderable>: Renderer {
        typealias Input = T

        let options: OutputOptions

        func render(_ input: T) throws {
            switch options.outputFormat {
            case .csv:
                print(try input.renderAsCSV())
            case .json:
                print(try input.renderAsJSON(pretty: options.pretty))
            case .yaml:
                print(try input.renderAsYAML())
            case .table:
                print(input.renderAsTable())
            }
        }
    }
}

/// Conformers to this protocol can be rendered as results in various formats.
///
/// By also conforming to `TableInfoProvider`, conformers gain default implementations of all these functions.
protocol ResultRenderable: Codable {
    /// Renders the receiver as a CSV string.
    func renderAsCSV() throws -> String

    /// Renders the receiver as a JSON string.
    func renderAsJSON() throws -> String

    /// Renders the receiver as a YAML string.
    func renderAsYAML() throws -> String

    /// Renders the receiver as a SwiftyTable string.
    func renderAsTable() -> String
}

extension ResultRenderable {
    func renderAsJSON() throws -> String {
        let jsonEncoder = JSONEncoder()
        // Withholding `.prettyPrinted` to maintain output that is parsable by default.
        // Consider adding the option `--pretty` if needed https://github.com/ittybittyapps/appstoreconnect-cli/issues/221
        jsonEncoder.outputFormatting = [.sortedKeys]
        let data = try jsonEncoder.encode(self)
        return try data.stringUTF8Encoded()
    }

    func renderAsJSON(pretty: Bool) throws -> String {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = pretty ? [.prettyPrinted, .sortedKeys] : [.sortedKeys]
        let data = try jsonEncoder.encode(self)
        return try data.stringUTF8Encoded()
    }

    func renderAsYAML() throws -> String {
        let yamlEncoder = YAMLEncoder()
        return try yamlEncoder.encode(self)
    }

    func render(options: OutputOptions) throws {
        try Renderers.ResultRendererWithOptions(options: options).render(self)
    }
}

/// Provides the necessary info to be able to render a table with SwiftyTable
protocol TableInfoProvider {
    /// Array of columns, with their headers, for display
    static func tableColumns() -> [TextTableColumn]

    /// A single row of table info, in the same order as `Self.tableColumns()`
    var tableRow: [CustomStringConvertible] { get }
}

extension Array: ResultRenderable where Element: TableInfoProvider & Codable {
    func renderAsCSV() throws -> String {
        let headers = Element.tableColumns().map(\.header)
        let rows = map { $0.tableRow.map { "\($0)" } }
        let wholeTable = [headers] + rows
        return try CSVWriter.encode(rows: wholeTable, into: String.self)
    }

    func renderAsTable() -> String {
        var table = TextTable(columns: Element.tableColumns())
        table.addRows(values: map(\.tableRow))
        return table.render()
    }
}

extension ResultRenderable where Self: TableInfoProvider {
    func renderAsCSV() throws -> String {
        let headers = Self.tableColumns().map(\.header)
        let row = tableRow.map { "\($0)" }
        let wholeTable = [headers] + [row]
        return try CSVWriter.encode(rows: wholeTable, into: String.self)
    }

    func renderAsTable() -> String {
        var table = TextTable(columns: Self.tableColumns())
        table.addRow(values: tableRow)
        return table.render()
    }
}
