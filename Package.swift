// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "bitrise-step-swift-clone",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/binarybirds/git-kit", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-tools-support-core", .upToNextMajor(from: "0.2.5")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "bitrise-step-swift-clone",
            dependencies: [
                .product(name: "GitKit", package: "git-kit"),
                .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core")
            ]),
        .testTarget(
            name: "bitrise-step-swift-cloneTests",
            dependencies: ["bitrise-step-swift-clone"]),
    ]
)
