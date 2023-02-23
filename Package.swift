// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JazzHealthCheck",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "JazzHealthCheck",
            targets: ["JazzHealthCheck"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/JazzFramework/Jazz.git", from: "0.0.8"),
        .package(url: "https://github.com/MarcoEidinger/OSInfo.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "JazzHealthCheck",
            dependencies: [
                .product(name: "JazzServer", package: "Jazz"),
                .product(name: "OSInfo", package: "OSInfo"),
            ]
        ),
        .testTarget(
            name: "JazzHealthCheckTests",
            dependencies: ["JazzHealthCheck"]
        ),
    ]
)
