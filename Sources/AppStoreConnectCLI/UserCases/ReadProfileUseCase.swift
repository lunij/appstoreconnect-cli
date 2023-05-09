// Copyright 2023 Itty Bitty Apps Pty Ltd

struct ReadProfileUseCase {
    let service: BagbutikServiceProtocol

    func readProfile(
        id: String,
        downloadPath: String?,
        outputOptions: OutputOptions
    ) async throws {
        let profile = try await ReadProfileOperation(service: service, options: .init(id: id)).execute()

        if let path = downloadPath {
            let processor = ProfileProcessor(path: .file(path: path))
            let file = try processor.write(profile)
            print("Provisioning Profile downloaded to: \(file.path)")
        }

        try profile.render(options: outputOptions)
        try profile.bundleIds?.render(options: outputOptions)
        try profile.certificates?.render(options: outputOptions)
        try profile.devices?.render(options: outputOptions)
    }
}
