// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Teplovisor",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    ],
    targets: [
        .executableTarget(name: "Teplovisor", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]),
    ]
)
