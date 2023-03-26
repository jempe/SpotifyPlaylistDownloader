// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "MyPackage",
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.4.1")
    ],
    targets: [
        .target(
            name: "SpotifyDownloader",
            dependencies: ["SwiftSoup"]
        )
    ]
)

