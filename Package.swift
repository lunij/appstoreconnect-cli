// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let package = Package(
    name: "appstoreconnect-cli",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "asc", targets: ["asc"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", exact: "1.1.3"),
        .package(url: "https://github.com/AvdLee/appstoreconnect-swift-sdk.git", from: "1.7.0"),
        .package(url: "https://github.com/dehesa/CodableCSV.git", from: "0.5.5"),
        .package(url: "https://github.com/JohnSundell/CollectionConcurrencyKit.git", from: "0.2.0"),
        .package(url: "https://github.com/JohnSundell/Files.git", from: "4.1.1"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.1"),
        .package(url: "https://github.com/MortenGregersen/Bagbutik.git", from: "5.1.0"),
        .package(url: "https://github.com/scottrhoyt/SwiftyTextTable.git", from: "0.9.0")
    ] + .plugins,
    targets: [
        .executableTarget(
            name: "asc",
            dependencies: ["AppStoreConnectCLI"],
            plugins: .default
        ),
        .target(
            name: "AppStoreConnectCLI",
            dependencies: [
                .product(name: "AppStoreConnect-Swift-SDK", package: "AppStoreConnect-Swift-SDK"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Bagbutik", package: "Bagbutik"),
                .product(name: "CodableCSV", package: "CodableCSV"),
                .product(name: "CollectionConcurrencyKit", package: "CollectionConcurrencyKit"),
                .product(name: "Files", package: "Files"),
                .product(name: "SwiftyTextTable", package: "SwiftyTextTable"),
                .product(name: "Yams", package: "Yams")
            ],
            plugins: .default
        ),
        .testTarget(
            name: "AppStoreConnectCLITests",
            dependencies: ["AppStoreConnectCLI"],
            resources: [
                .copy("Fixtures")
            ],
            plugins: .default
        )
    ]
)

extension [Target.PluginUsage] {
    static var `default`: [Element] {
        Environment.isDevelopment ? [
            .plugin(name: "SwiftFormatPrebuildPlugin", package: "SwiftFormatPlugin"),
            .plugin(name: "SwiftLintPrebuildFix", package: "SwiftLintPlugin"),
            .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
        ] : []
    }
}

extension [Package.Dependency] {
    static var plugins: [Element] {
        Environment.isDevelopment ? [
            .package(url: "git@github.com:lunij/SwiftFormatPlugin", from: "0.50.7"),
            .package(url: "git@github.com:lunij/SwiftLintPlugin", from: "0.50.3")
        ] : []
    }
}

enum Environment {
    static var isDevelopment: Bool {
        ProcessInfo.processInfo.environment["DEV"] == "true"
    }
}
