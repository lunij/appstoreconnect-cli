// Copyright 2023 Itty Bitty Apps Pty Ltd

extension Collection {
    var isNotEmpty: Bool {
        isEmpty == false
    }

    var nilIfEmpty: Self? {
        isEmpty ? nil : self
    }
}
