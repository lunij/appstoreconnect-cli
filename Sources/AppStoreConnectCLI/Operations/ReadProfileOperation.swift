// Copyright 2023 Itty Bitty Apps Pty Ltd

struct ReadProfileOperation: APIOperation {
    struct Options {
        let id: String
    }

    let service: BagbutikServiceProtocol
    let options: Options

    func execute() async throws -> Profile {
        let response = try await service.request(
            .getProfileV1(
                id: options.id,
                includes: [.bundleId, .certificates, .devices]
            )
        )

        return Profile(response.data, includes: response.included ?? [])
    }
}
