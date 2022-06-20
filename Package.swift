// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PayUIndia-Custom-Browser",
    platforms: [.iOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PayUIndia-Custom-Browser",
            targets: ["PayUIndia-CustomBrowserTarget"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "PayUIndia-Analytics",url: "https://github.com/payu-intrepos/PayUAnalytics-iOS", from: "3.0.0")
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
