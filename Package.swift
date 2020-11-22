// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SMLinkPreview",
    products: [
        .library(
            name: "SMLinkPreview",
            targets: ["SMLinkPreview"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SMLinkPreview",
            dependencies: [],
            resources: [
                .process("LinkPreview.xib")
            ]
        )
        // Currently the tests are in the Cocoapods example. Would be good to move them here or make them available here.
    ]
)

