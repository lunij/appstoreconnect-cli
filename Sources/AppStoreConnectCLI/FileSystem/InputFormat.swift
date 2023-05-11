// Copyright 2023 Itty Bitty Apps Pty Ltd

import Foundation

public enum InputFormat: String, CaseIterable, Codable {
    case json
    case yaml
    case csv
}
