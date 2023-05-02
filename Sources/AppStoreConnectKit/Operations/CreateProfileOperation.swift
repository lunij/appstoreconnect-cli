// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import Model

struct CreateProfileOperation: APIOperation {

    struct Options {
        let name: String
        let bundleIdResourceId: String
        let profileType: ProfileType
        let certificateIds: [String]
        let deviceIds: [String]
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> Model.Profile {
        let shouldOmitDeviceIds = [.iOSAppStore, .macAppStore, .tvOSAppStore]
            .contains(options.profileType)

        let profile = try await service.request(.createProfileV1(
            requestBody: .init(data: .init(
                attributes: .init(
                    name: options.name,
                    profileType: options.profileType
                ),
                relationships: .init(
                    bundleId: .init(data: .init(id: options.bundleIdResourceId)),
                    certificates: .init(data: options.certificateIds.map { .init(id: $0) }),
                    devices: shouldOmitDeviceIds ? nil : .init(data: options.deviceIds.map { .init(id: $0) })
                )
            ))
        ))
        .data

        return Model.Profile(profile)
    }
}
