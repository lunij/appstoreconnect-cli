// Copyright 2023 Itty Bitty Apps Pty Ltd

import Bagbutik
import Model
import SwiftyTextTable

extension Model.Profile {
    init(_ profile: Bagbutik.Profile, includes: [Bagbutik.ProfileResponse.Included]) {
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
            bundleIds: bundleIds.map(Model.BundleId.init).nilIfEmpty,
            certificates: certificates.map(Model.Certificate.init).nilIfEmpty,
            devices: devices.map(Model.Device.init).nilIfEmpty
        )
    }

    init(_ profile: Bagbutik.Profile, includes: [Bagbutik.ProfilesResponse.Included]) {
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
            bundleIds: bundleIds.map(Model.BundleId.init).nilIfEmpty,
            certificates: certificates.map(Model.Certificate.init).nilIfEmpty,
            devices: devices.map(Model.Device.init).nilIfEmpty
        )
    }

    init(
        _ profile: Bagbutik.Profile,
        bundleIds: [Bagbutik.BundleId] = [],
        certificates: [Bagbutik.Certificate] = [],
        devices: [Bagbutik.Device] = []
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
            bundleIds: bundleIds.map(Model.BundleId.init).nilIfEmpty,
            certificates: certificates.map(Model.Certificate.init).nilIfEmpty,
            devices: devices.map(Model.Device.init).nilIfEmpty
        )
    }
}

extension Model.Profile: ResultRenderable, TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        return [
            TextTableColumn(header: "ID"),
            TextTableColumn(header: "UUID"),
            TextTableColumn(header: "Name"),
            TextTableColumn(header: "Platform"),
            TextTableColumn(header: "State"),
            TextTableColumn(header: "Type"),
            TextTableColumn(header: "Created Date"),
            TextTableColumn(header: "Expiration Date"),
        ]
    }

    var tableRow: [CustomStringConvertible] {
        return [
            id,
            uuid ?? "",
            name ?? "",
            platform ?? "",
            profileState ?? "",
            profileType ?? "",
            createdDate?.formattedDate ?? "",
            expirationDate?.formattedDate ?? "",
        ]
    }
}

private extension [Bagbutik.ProfileResponse.Included] {
    var unwrapped: ([Bagbutik.BundleId], [Bagbutik.Certificate], [Bagbutik.Device]) {
        var bundleIds: [Bagbutik.BundleId] = []
        var certificates: [Bagbutik.Certificate] = []
        var devices: [Bagbutik.Device] = []

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

private extension [Bagbutik.ProfilesResponse.Included] {
    var unwrapped: ([Bagbutik.BundleId], [Bagbutik.Certificate], [Bagbutik.Device]) {
        var bundleIds: [Bagbutik.BundleId] = []
        var certificates: [Bagbutik.Certificate] = []
        var devices: [Bagbutik.Device] = []

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
