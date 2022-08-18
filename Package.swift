// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SerialSwift",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SerialSwift",
            targets: ["SerialSwift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Flowduino/ThreadSafeSwift.git", .upToNextMajor(from: "1.1.0")),
        .package(url: "https://github.com/Flowduino/Observable.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/Flowduino/EventDrivenSwift.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/armadsen/ORSSerialPort.git", .upToNextMajor(from: "2.1.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SerialSwift",
            dependencies: [
                .product(name: "ThreadSafeSwift", package: "ThreadSafeSwift"),
                .product(name: "Observable", package: "Observable"),
                .product(name: "EventDrivenSwift", package: "EventDrivenSwift"),
                .product(name: "ORSSerial", package: "ORSSerialPort")
            ]
        ),
        .testTarget(
            name: "SerialSwiftTests",
            dependencies: ["SerialSwift",
                           .product(name: "ThreadSafeSwift", package: "ThreadSafeSwift"),
                           .product(name: "Observable", package: "Observable"),
                           .product(name: "EventDrivenSwift", package: "EventDrivenSwift"),
                           .product(name: "ORSSerial", package: "ORSSerialPort")
                       ]
                   ),
    ]
)
