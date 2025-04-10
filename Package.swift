// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TestMigrator",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(name: "test-migrator-cli", targets: ["TestMigratorCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "601.0.0"),
        .package(url: "https://github.com/swiftlang/swift-format.git", from: "601.0.0"),
        .package(url: "https://github.com/Quick/Quick", exact: "7.2.0"),
        .package(url: "https://github.com/Quick/Nimble", exact: "12.2.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
    ],
    targets: [
        .executableTarget(
            name: "TestMigratorCLI",
            dependencies: [
                .target(name: "MigratorLib"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .target(
            name: "MigratorLib",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ]),
        .target(
            name: "FormatterLib",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftFormat", package: "swift-format"),
            ]),
        .testTarget(
            name: "MigratorLibTests",
            dependencies: [
                .target(name: "MigratorLib"),
                .target(name: "FormatterLib"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "SwiftFormat", package: "swift-format"),
            ]),
        .testTarget(
            name: "ExampleXCTests",
            dependencies: [
                .product(name: "Nimble", package: "Nimble")
            ]),
        .testTarget(
            name: "ExampleTests",
            dependencies: []),
        .testTarget(
            name: "ExampleSpecs",
            dependencies: [
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble"),
            ]),
    ]
)
