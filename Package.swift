// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "bitrise-step-swift-clone",
    dependencies: [
        .package(url: "https://github.com/binarybirds/git-kit", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-tools-support-core", .upToNextMajor(from: "0.2.5")),
    ],
    targets: [
        .executableTarget(
            name: "bitrise-step-swift-clone",
            dependencies: [
                .product(name: "GitKit", package: "git-kit"),
                .product(name: "TSCBasic", package: "swift-tools-support-core"),
            ]
        ),
        .testTarget(
            name: "bitrise-step-swift-cloneTests",
            dependencies: [
                "bitrise-step-swift-clone",
                .product(name: "TSCTestSupport", package: "swift-tools-support-core"),
            ]
        ),
    ]
)
