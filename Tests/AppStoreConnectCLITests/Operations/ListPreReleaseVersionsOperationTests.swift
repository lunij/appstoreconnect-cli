// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Combine
import Foundation
import XCTest
@testable import AppStoreConnectCLI

final class ListPreReleaseVersionsOperationTests: XCTestCase {
    typealias Operation = ListPreReleaseVersionsOperation
    typealias Options = Operation.Options

    let successRequestor = OneEndpointTestRequestor(
        response: { _ in Future { $0(.success(dataResponse)) } }
    )

    func testReturnsOnePreReleaseVersion() throws {
        let operation = Operation(options: Options(filterAppIds: [], filterVersions: [], filterPlatforms: [], sort: nil))
        let output = try operation.execute(with: successRequestor).await()
        XCTAssertEqual(output.first?.preReleaseVersion.attributes?.version, "1.1")
    }

    static let dataResponse: PreReleaseVersionsResponse = jsonDecoder.decodeFixture(named: "v1/prerelease_version/list_prerelease_version")
}
