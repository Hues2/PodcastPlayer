// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PodcastPlayerAudioKit",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "PodcastPlayerAudioKit",
            targets: ["PodcastPlayerAudioKit"]
        ),
    ],
    targets: [
        .target(
            name: "PodcastPlayerAudioKit"
        ),
        .testTarget(
            name: "PodcastPlayerAudioKitTests",
            dependencies: ["PodcastPlayerAudioKit"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
