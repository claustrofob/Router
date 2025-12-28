// swift-tools-version:6.0.0

import PackageDescription

let package = Package(
    name: "Router",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Router",
            targets: ["Router"]
        ),
    ],
    targets: [
        .target(
            name: "Router"
        ),
    ]
)
