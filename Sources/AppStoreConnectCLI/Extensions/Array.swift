// Copyright 2023 Itty Bitty Apps Pty Ltd

extension Array where Element: Hashable {
    func removeDuplicates() -> [Element] {
        Array(Set(self))
    }
}
