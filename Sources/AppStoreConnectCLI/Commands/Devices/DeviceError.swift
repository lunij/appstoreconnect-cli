// Copyright 2023 Itty Bitty Apps Pty Ltd

enum DeviceError: Error, CustomStringConvertible {
    case deviceNotFound(String)
    case deviceNotUnique(String)

    var description: String {
        switch self {
        case let .deviceNotFound(udid):
            return "Unable to find device with UDID \(udid)"
        case let .deviceNotUnique(udid):
            return "The device's UDID \(udid) is not unique"
        }
    }
}
