// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik

struct ReadBuildLocalizationOperation: APIOperation {

    struct Options {
        let id: String
        let locale: String
    }

    enum Error: Swift.Error, CustomStringConvertible {
        case betaBuildLocalizationNotFound

        var description: String {
            switch self {
            case .betaBuildLocalizationNotFound:
                return "Unable to find Localization info for build."
            }
        }
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> BetaBuildLocalization {
        let betaBuildLocalizations = try await service
            .requestAllPages(.listBetaBuildLocalizationsForBuildV1(id: options.id))
            .data
            .filter { betaBuildLocalization in
                betaBuildLocalization.attributes?.locale?.lowercased() == options.locale.lowercased()
            }

        guard let betaBuildLocalization = betaBuildLocalizations.first else {
            throw Error.betaBuildLocalizationNotFound
        }

        return betaBuildLocalization
    }
}
