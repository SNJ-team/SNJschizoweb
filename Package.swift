// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "SNJschizoweb",
    platforms: [
       .macOS(.v15)
    ],
    products: [
        .library(
            name: "SNJschizoweb",
            type: .dynamic,
            targets: ["SNJschizoweb"]
            
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-java.git", branch: "main"),
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
    ],
    targets: [
        .target(
            name: "SNJschizoweb",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "SwiftJava", package: "swift-java"),
                .product(name: "SwiftRuntimeFunctions", package: "swift-java"),
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        ),
        .testTarget(
            name: "SNJschizowebTests",
            dependencies: [
                .target(name: "SNJschizoweb"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
        )
    ]
)
