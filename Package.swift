// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CHSDK",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "CHSDK",
            targets: ["CHSDK"]),
        .library(
            name: "CHSwiftyMediator",
            targets: ["CHSwiftyMediator"]),
//        .library(
//            name: "CHNetworkLayer",
//            targets: ["CHNetworkLayer"]),
        .library(
            name: "CHPlayerView",
            targets: ["CHPlayerView"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
//        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.9.1")

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "CHSDK",
            dependencies: []),
        .target(
            name: "CHSwiftyMediator",
            dependencies: []),
//        .target(
//            name: "CHNetworkLayer",
//            dependencies: []),
        .target(
            name: "CHPlayerView",
            dependencies: []),
        .testTarget(
            name: "CHSDKTests",
            dependencies: ["CHSDK"]),
    ]
)
