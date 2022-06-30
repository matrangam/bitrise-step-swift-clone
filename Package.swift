// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "bitrise-step-swift-test",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/binarybirds/git-kit", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "bitrise-step-swift-test",
            dependencies: [
                .product(name: "GitKit", package: "git-kit"),
            ]),
        .testTarget(
            name: "bitrise-step-swift-testTests",
            dependencies: ["bitrise-step-swift-test"]),
    ]
)
