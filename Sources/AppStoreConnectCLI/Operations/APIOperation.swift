// Copyright 2023 Itty Bitty Apps Pty Ltd

protocol APIOperation {
    associatedtype Options
    associatedtype Output
    associatedtype Service

    init(service: Service, options: Options)

    func execute() async throws -> Output
}
