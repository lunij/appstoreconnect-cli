// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
        .package(url: "https://github.com/JohnSundell/Files.git", from: "4.1.1"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.1"),
        .package(url: "https://github.com/scottrhoyt/SwiftyTextTable.git", from: "0.9.0")
    ],
    targets: [
        .executableTarget(name: "asc", dependencies: ["AppStoreConnectCLI"]),
        .target(
            name: "AppStoreConnectCLI",
            dependencies: [
                .product(name: "AppStoreConnect-Swift-SDK", package: "AppStoreConnect-Swift-SDK"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "CodableCSV", package: "CodableCSV"),
                .product(name: "SwiftyTextTable", package: "SwiftyTextTable"),
                .product(name: "Yams", package: "Yams"),
                .target(name: "Model"),
                .target(name: "FileSystem")
            ]
        ),
        .testTarget(
            name: "AppStoreConnectCLITests",
            dependencies: ["AppStoreConnectCLI"],
            resources: [
                .copy("Models/Fixtures.bundle")
            ]
        ),
        .target(
            name: "FileSystem",
            dependencies: [
                .product(name: "CodableCSV", package: "CodableCSV"),
                .product(name: "Yams", package: "Yams"),
                .product(name: "Files", package: "Files"),
            ]
        ),
        .target(name: "Model")
    ]
)
