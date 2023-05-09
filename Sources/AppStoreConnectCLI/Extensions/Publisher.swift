// Copyright 2023 Itty Bitty Apps Pty Ltd

import Combine
import Foundation

enum PublisherAwaitError: LocalizedError {
    case timedOut(timeout: DispatchTime)
    case expectedOutput
    case expectedSingleOutput(outputCount: Int)

    var errorDescription: String? {
        switch self {
        case let .timedOut(timeout):
            return "Expected publisher output but timed out with timeout: \(timeout)"
        case .expectedOutput:
            return "Expected publisher output but none received"
        case let .expectedSingleOutput(outputCount):
            return "Expected single publisher output but received \(outputCount)"
        }
    }
}

extension Publisher {
    func await(timeout: DispatchTime = .distantFuture) throws -> Output {
        let allOutput = try awaitMany(timeout: timeout)

        guard let output = allOutput.first, allOutput.count == 1 else {
            throw PublisherAwaitError.expectedSingleOutput(outputCount: allOutput.count)
        }

        return output
    }

    func awaitMany(timeout: DispatchTime = .distantFuture) throws -> [Output] {
        var result: Result<[Output], Failure>?

        let dispatchQueue = DispatchQueue.global(qos: .userInteractive)
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()

        let cancellable = subscribe(on: dispatchQueue)
            .collect()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case let .failure(failure):
                        result = .failure(failure)
                    }

                    dispatchGroup.leave()
                },
                receiveValue: {
                    result = .success($0)
                }
            )

        let timeoutResult = dispatchGroup.wait(timeout: timeout)
        cancellable.cancel()

        switch (result, timeoutResult) {
        case (_, .timedOut):
            throw PublisherAwaitError.timedOut(timeout: timeout)
        case (.none, .success):
            throw PublisherAwaitError.expectedOutput
        case let (.some(.success(output)), .success):
            return output
        case let (.some(.failure(error)), .success):
            throw error
        }
    }
}
