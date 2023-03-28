// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let VERSION_ANALYTICS_KIT: PackageDescription.Version = "3.0.0"

let package = Package(
    name: "PayUIndia-Custom-Browser",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "PayUIndia-Custom-Browser",
            targets: ["PayUIndia-CustomBrowserTarget"]
        )
    ],
    dependencies: [
        .package(name: "PayUIndia-Analytics", url: "https://github.com/payu-intrepos/PayUAnalytics-iOS", from: VERSION_ANALYTICS_KIT)
    ],
    targets: [
        .binaryTarget(name: "PayUCustomBrowser", path: "./PayUCustomBrowser.xcframework"),
        .target(
            name: "PayUIndia-CustomBrowserTarget",
            dependencies: [
                "PayUCustomBrowser",
                "PayUIndia-Analytics"
            ],
            path: "PayUIndia-CustomBrowserWrapper"
        )
    ]
)
