// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QuickToXCTestMigrator",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "migrator-cli", targets: ["MigratorCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax", from: "509.0.0"),
        .package(url: "https://github.com/Quick/Quick", from: "7.0.0"),
        .package(url: "https://github.com/Quick/Nimble", from: "12.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    ],
    targets: [
        .executableTarget(name: "MigratorCLI", dependencies: [
            .target(name: "MigratorLib"),
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]),
        .target(name: "MigratorLib", dependencies: [
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftParser", package: "swift-syntax"),
            .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        ]),
        .testTarget(name: "MigratorLibTests", dependencies: [
            .target(name: "MigratorLib"),
            .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        ]),
        .testTarget(name: "ExampleTests", dependencies: [
            .product(name: "Nimble", package: "Nimble"),
        ]),
        .testTarget(name: "ExampleSpecs", dependencies: [
            .product(name: "Quick", package: "Quick"),
            .product(name: "Nimble", package: "Nimble"),
        ]),
    ]
)
