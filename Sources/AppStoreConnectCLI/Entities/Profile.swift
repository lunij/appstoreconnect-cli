// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik_Models
import Foundation
import SwiftyTextTable

struct Profile: Codable, Equatable {
    let id: String
    let name: String?
    let platform: String?
    let profileContent: String?
    let uuid: String?
    let createdDate: Date?
    let profileState: String?
    let profileType: String?
    let expirationDate: Date?
    let bundleIds: [BundleId]?
    let certificates: [Certificate]?
    let devices: [Device]?
}

// MARK: - Extensions

extension Profile {
    init(_ profile: Bagbutik_Models.Profile, includes: [Bagbutik_Models.ProfileResponse.Included]) {
        let (bundleIds, certificates, devices) = includes.unwrapped
        let attributes = profile.attributes

        self.init(
            id: profile.id,
            name: attributes?.name,
            platform: attributes?.platform?.rawValue,
            profileContent: attributes?.profileContent,
            uuid: attributes?.uuid,
            createdDate: attributes?.createdDate,
            profileState: attributes?.profileState?.rawValue,
            profileType: attributes?.profileType?.rawValue,
            expirationDate: attributes?.expirationDate,
            bundleIds: bundleIds.map(BundleId.init).nilIfEmpty,
            certificates: certificates.map(Certificate.init).nilIfEmpty,
            devices: devices.map(Device.init).nilIfEmpty
        )
    }

    init(_ profile: Bagbutik_Models.Profile, includes: [Bagbutik_Models.ProfilesResponse.Included]) {
        let (bundleIds, certificates, devices) = includes.unwrapped
        let attributes = profile.attributes

        self.init(
            id: profile.id,
            name: attributes?.name,
            platform: attributes?.platform?.rawValue,
            profileContent: attributes?.profileContent,
            uuid: attributes?.uuid,
            createdDate: attributes?.createdDate,
            profileState: attributes?.profileState?.rawValue,
            profileType: attributes?.profileType?.rawValue,
            expirationDate: attributes?.expirationDate,
            bundleIds: bundleIds.map(BundleId.init).nilIfEmpty,
            certificates: certificates.map(Certificate.init).nilIfEmpty,
            devices: devices.map(Device.init).nilIfEmpty
        )
    }

    init(
        _ profile: Bagbutik_Models.Profile,
        bundleIds: [Bagbutik_Models.BundleId] = [],
        certificates: [Bagbutik_Models.Certificate] = [],
        devices: [Bagbutik_Models.Device] = []
    ) {
        let attributes = profile.attributes
        self.init(
            id: profile.id,
            name: attributes?.name,
            platform: attributes?.platform?.rawValue,
            profileContent: attributes?.profileContent,
            uuid: attributes?.uuid,
            createdDate: attributes?.createdDate,
            profileState: attributes?.profileState?.rawValue,
            profileType: attributes?.profileType?.rawValue,
            expirationDate: attributes?.expirationDate,
            bundleIds: bundleIds.map(BundleId.init).nilIfEmpty,
            certificates: certificates.map(Certificate.init).nilIfEmpty,
            devices: devices.map(Device.init).nilIfEmpty
        )
    }
}

extension Profile: ResultRenderable {}

extension Profile: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        [
            TextTableColumn(header: "ID"),
            TextTableColumn(header: "UUID"),
            TextTableColumn(header: "Name"),
            TextTableColumn(header: "Platform"),
            TextTableColumn(header: "State"),
            TextTableColumn(header: "Type"),
            TextTableColumn(header: "Created Date"),
            TextTableColumn(header: "Expiration Date")
        ]
    }

    var tableRow: [CustomStringConvertible] {
        [
            id,
            uuid ?? "",
            name ?? "",
            platform ?? "",
            profileState ?? "",
            profileType ?? "",
            createdDate?.formattedDate ?? "",
            expirationDate?.formattedDate ?? ""
        ]
    }
}

private extension [Bagbutik_Models.ProfileResponse.Included] {
    var unwrapped: ([Bagbutik_Models.BundleId], [Bagbutik_Models.Certificate], [Bagbutik_Models.Device]) {
        var bundleIds: [Bagbutik_Models.BundleId] = []
        var certificates: [Bagbutik_Models.Certificate] = []
        var devices: [Bagbutik_Models.Device] = []

        for include in self {
            switch include {
            case let .bundleId(bundleId):
                bundleIds.append(bundleId)
            case let .certificate(certificate):
                certificates.append(certificate)
            case let .device(device):
                devices.append(device)
            }
        }

        return (bundleIds, certificates, devices)
    }
}

private extension [Bagbutik_Models.ProfilesResponse.Included] {
    var unwrapped: ([Bagbutik_Models.BundleId], [Bagbutik_Models.Certificate], [Bagbutik_Models.Device]) {
        var bundleIds: [Bagbutik_Models.BundleId] = []
        var certificates: [Bagbutik_Models.Certificate] = []
        var devices: [Bagbutik_Models.Device] = []

        for include in self {
            switch include {
            case let .bundleId(bundleId):
                bundleIds.append(bundleId)
            case let .certificate(certificate):
                certificates.append(certificate)
            case let .device(device):
                devices.append(device)
            }
        }

        return (bundleIds, certificates, devices)
    }
}
