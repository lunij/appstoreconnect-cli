// Copyright 2023 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Foundation
import Yams

extension AppStoreConnectService {
    convenience init(authenticationYmlPath: String) throws {
        let authYml = try String(contentsOfFile: authenticationYmlPath)
        let configuration: APIConfiguration = try YAMLDecoder().decode(from: authYml)
        self.init(configuration: configuration)
    }
}
