// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fill-hole",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "fill-hole", targets: ["fill-hole"]),
        .library(name: "FillHoleCommand", targets: ["FillHoleCommand"]),
        .library(name: "FillHoleLib", targets: ["FillHoleCommand"]),
        .library(name: "GrayscaleIOLib", targets: ["GrayscaleIOLib"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.0"),
    ],
    targets: [
        .executableTarget(
            name: "fill-hole",
            dependencies: ["FillHoleCommand"]
        ),
        .target(
            name: "FillHoleCommand",
            dependencies: [
                "GrayscaleIOLib",
                "FillHoleLib",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "FillHoleCommandTests",
            dependencies: ["FillHoleCommand"]
        ),
        .target(name: "FillHoleLib"),
        .testTarget(
            name: "FillHoleLibTests",
            dependencies: ["FillHoleLib"]
        ),
        .target(name: "GrayscaleIOLib"),
        .testTarget(
            name: "GrayscaleIOLibTests",
            dependencies: ["GrayscaleIOLib"],
            resources: [.process("Resources")]
        ),
    ]
)
