// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import Foundation
import struct Model.Certificate

struct ListCertificatesOperation: APIOperation {

    typealias Filter = ListCertificatesV1.Filter

    enum Error: LocalizedError {
        case certificatesNotFound

        var errorDescription: String? {
            switch self {
            case .certificatesNotFound:
                return "No certificates found"
            }
        }
    }

    struct Options {
        var filterSerial: String?
        var sorts: [ListCertificatesV1.Sort]?
        var filterType: ListCertificatesV1.Filter.CertificateType?
        var filterDisplayName: String?
        var limit: Int?
    }

    var filters: [Filter] {
        var filters: [Filter] = []

        if let filterSerial = options.filterSerial {
            filters.append(.serialNumber([filterSerial]))
        }

        if let filterType = options.filterType {
            filters.append(.certificateType([filterType]))
        }

        if let filterDisplayName = options.filterDisplayName {
            filters.append(.displayName([filterDisplayName]))
        }

        return filters
    }

    let service: BagbutikService
    let options: Options

    func execute() async throws -> [Model.Certificate] {
        let certificates = try await service
            .requestAllPages(.listCertificatesV1Customized(
                filters: filters,
                sorts: options.sorts,
                limit: options.limit
            ))
            .data

        if certificates.isEmpty {
            throw Error.certificatesNotFound
        }

        return certificates.map(Model.Certificate.init)
    }
}

extension Request {
    static func listCertificatesV1Customized(
        fields: [ListCertificatesV1.Field]? = nil,
        filters: [ListCertificatesV1.Filter]? = nil,
        sorts: [ListCertificatesV1.Sort]? = nil,
        limit: Int? = nil
    ) -> Request<CertificatesResponseCustomized, ErrorResponse> {
        .init(
            path: "/v1/certificates",
            method: .get,
            parameters: .init(
                fields: fields,
                filters: filters,
                sorts: sorts,
                limit: limit
            )
        )
    }
}

struct CertificatesResponseCustomized: Codable, PagedResponse {
    typealias Data = LossyCertificate

    let data: [LossyCertificate]
    let links: PagedDocumentLinks
    var meta: PagingInformation?
}

struct LossyCertificate: Codable {
    let id: String
    let links: ResourceLinks
    var attributes: Attributes?
    var type: String { "certificates" }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        links = try container.decode(ResourceLinks.self, forKey: .links)
        attributes = try container.decodeIfPresent(Attributes.self, forKey: .attributes)
        if try container.decode(String.self, forKey: .type) != type {
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Not matching \(type)")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(links, forKey: .links)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(attributes, forKey: .attributes)
    }

    private enum CodingKeys: String, CodingKey {
        case attributes
        case id
        case links
        case type
    }

    struct Attributes: Codable {
        var certificateContent: String?
        var certificateType: LossyCertificateType?
        var displayName: String?
        var expirationDate: Date?
        var name: String?
        var platform: BundleIdPlatform?
        var serialNumber: String?
    }
}

/// This certificate type allows a custom value.
/// It is necessary because Apple's OpenAPI spec is missing values that are in use already.
/// Generated Swift APIs like Bagbutik support strict values only.
/// That's why they fail on decoding unspecified values.
enum LossyCertificateType: RawRepresentable, Codable, CaseIterable {
    static var allCases: [LossyCertificateType] {
        [
            .iOSDevelopment,
            .iOSDistribution,
            .macAppDistribution,
            .macInstallerDistribution,
            .macAppDevelopment,
            .developerIdKext,
            .developerIdApplication,
            .development,
            .distribution,
            .passTypeId,
            .passTypeIdWithNfc
        ]
    }

    case iOSDevelopment
    case iOSDistribution
    case macAppDistribution
    case macInstallerDistribution
    case macAppDevelopment
    case developerIdKext
    case developerIdApplication
    case development
    case distribution
    case passTypeId
    case passTypeIdWithNfc
    case custom(String)

    init?(rawValue: String) {
        switch rawValue {
        case "IOS_DEVELOPMENT": self = .iOSDevelopment
        case "IOS_DISTRIBUTION": self = .iOSDistribution
        case "MAC_APP_DISTRIBUTION": self = .macAppDistribution
        case "MAC_INSTALLER_DISTRIBUTION": self = .macInstallerDistribution
        case "MAC_APP_DEVELOPMENT": self = .macAppDevelopment
        case "DEVELOPER_ID_KEXT": self = .developerIdKext
        case "DEVELOPER_ID_APPLICATION": self = .developerIdApplication
        case "DEVELOPMENT": self = .development
        case "DISTRIBUTION": self = .distribution
        case "PASS_TYPE_ID": self = .passTypeId
        case "PASS_TYPE_ID_WITH_NFC": self = .passTypeIdWithNfc
        default: self = .custom(rawValue)
        }
    }

    var rawValue: String {
        switch self {
        case .iOSDevelopment: return "IOS_DEVELOPMENT"
        case .iOSDistribution: return "IOS_DISTRIBUTION"
        case .macAppDistribution: return "MAC_APP_DISTRIBUTION"
        case .macInstallerDistribution: return "MAC_INSTALLER_DISTRIBUTION"
        case .macAppDevelopment: return "MAC_APP_DEVELOPMENT"
        case .developerIdKext: return "DEVELOPER_ID_KEXT"
        case .developerIdApplication: return "DEVELOPER_ID_APPLICATION"
        case .development: return "DEVELOPMENT"
        case .distribution: return "DISTRIBUTION"
        case .passTypeId: return "PASS_TYPE_ID"
        case .passTypeIdWithNfc: return "PASS_TYPE_ID_WITH_NFC"
        case let .custom(rawValue): return rawValue
        }
    }
}
