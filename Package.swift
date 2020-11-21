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
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SMLinkPreview",
            dependencies: [],
            resources: [
                .copy("LinkPreview.xib")
            ]
        )
        // Currently the tests are in the Cocoapods example. Would be good to move them here or make them available here.
    ]
)

/*
.target(
   name: "HelloWorldProgram",
   dependencies: [], 
   resources: [.copy("README.md"), .copy("image.png")]
)
*/