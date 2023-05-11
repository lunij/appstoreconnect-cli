// Copyright 2023 Itty Bitty Apps Pty Ltd

@testable import Bagbutik_Core

final class BagbutikServiceOverrideMock: BagbutikService {
    init(fetchData: @escaping FetchData) {
        super.init(jwt: try! .fake(), fetchData: fetchData)
    }
}
