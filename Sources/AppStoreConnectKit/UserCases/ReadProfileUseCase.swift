// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import FileSystem
import struct Model.Profile

struct ReadProfileUseCase {
    let service: BagbutikService

    func readProfile(
        id: String,
        downloadPath: String?,
        outputOptions: OutputOptions
    ) async throws {
        let profile = try await ReadProfileOperation(service: service, options: .init(id: id)).execute()

        if let path = downloadPath {
            let processor = ProfileProcessor(path: .folder(path: path))
            let file = try processor.write(profile)
            print("Provisioning Profile downloaded to: \(file.path)")
        }

        profile.render(options: outputOptions)
        profile.bundleIds?.render(options: outputOptions)
        profile.certificates?.render(options: outputOptions)
        profile.devices?.render(options: outputOptions)
    }
}
