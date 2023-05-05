// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import CodableCSV
import Combine
import Foundation
import SwiftyTextTable
import Yams

protocol Renderer {
    associatedtype Input

    func render(_ input: Input)
}

enum Renderers {
    struct ResultRendererWithOptions<T: ResultRenderable>: Renderer {
        typealias Input = T

        let options: OutputOptions

        func render(_ input: T) {
            switch options.outputFormat {
            case .csv:
                print(input.renderAsCSV())
            case .json:
                print(input.renderAsJSON(pretty: options.pretty))
            case .yaml:
                print(input.renderAsYAML())
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
    func renderAsCSV() -> String

    /// Renders the receiver as a JSON string.
    func renderAsJSON() -> String

    /// Renders the receiver as a YAML string.
    func renderAsYAML() -> String

    /// Renders the receiver as a SwiftyTable string.
    func renderAsTable() -> String
}

extension ResultRenderable {
    func renderAsJSON() -> String {
        let jsonEncoder = JSONEncoder()
        // Withholding `.prettyPrinted` to maintain output that is parsable by default.
        // Consider adding the option `--pretty` if needed https://github.com/ittybittyapps/appstoreconnect-cli/issues/221
        jsonEncoder.outputFormatting = [.sortedKeys]
        let json = try! jsonEncoder.encode(self) // swiftlint:disable:this force_try
        return String(data: json, encoding: .utf8)!
    }

    func renderAsJSON(pretty: Bool) -> String {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = pretty ? [.prettyPrinted, .sortedKeys] : [.sortedKeys]
        let json = try! jsonEncoder.encode(self) // swiftlint:disable:this force_try
        return String(data: json, encoding: .utf8)!
    }

    func renderAsYAML() -> String {
        let yamlEncoder = YAMLEncoder()
        let yaml = try! yamlEncoder.encode(self) // swiftlint:disable:this force_try
        return yaml
    }

    func render(options: OutputOptions) {
        Renderers.ResultRendererWithOptions(options: options).render(self)
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
    func renderAsCSV() -> String {
        let headers = Element.tableColumns().map(\.header)
        let rows = map { $0.tableRow.map { "\($0)" } }
        let wholeTable = [headers] + rows

        return try! CSVWriter.encode(rows: wholeTable, into: String.self) // swiftlint:disable:this force_try
    }

    func renderAsTable() -> String {
        var table = TextTable(columns: Element.tableColumns())
        table.addRows(values: map(\.tableRow))
        return table.render()
    }
}

extension ResultRenderable where Self: TableInfoProvider {
    func renderAsCSV() -> String {
        let headers = Self.tableColumns().map(\.header)
        let row = tableRow.map { "\($0)" }
        let wholeTable = [headers] + [row]

        return try! CSVWriter.encode(rows: wholeTable, into: String.self) // swiftlint:disable:this force_try
    }

    func renderAsTable() -> String {
        var table = TextTable(columns: Self.tableColumns())
        table.addRow(values: tableRow)
        return table.render()
    }
}
