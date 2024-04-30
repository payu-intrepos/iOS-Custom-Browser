// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let VERSION_ANALYTICS_KIT: PackageDescription.Version = "3.0.1"
let VERSION_COMMON_UI: PackageDescription.Version = "1.2.1"

let package = Package(
    name: "PayUIndia-Custom-Browser",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "PayUIndia-Custom-Browser",
            targets: ["PayUIndia-CustomBrowserTarget"]
        )
    ],
    dependencies: [
        .package(name: "PayUIndia-Analytics", url: "https://github.com/payu-intrepos/PayUAnalytics-iOS", from: VERSION_ANALYTICS_KIT),
        .package(name: "PayUIndia-CommonUI", url: "https://github.com/payu-intrepos/PayUCommonUI-iOS", from: VERSION_COMMON_UI)
    ],
    targets: [
        .binaryTarget(name: "PayUCustomBrowser", path: "./PayUCustomBrowser.xcframework"),
        .target(
            name: "PayUIndia-CustomBrowserTarget",
            dependencies: [
                "PayUCustomBrowser",
                "PayUIndia-Analytics",
                "PayUIndia-CommonUI"
            ],
            path: "PayUIndia-CustomBrowserWrapper"
        )
    ]
)
