// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "ipma_api",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        // 🌐 GraphQL
        .package(name: "GraphQLKit", url: "https://github.com/rafaelfrancisco-dev/graphql-kit.git", .branch("master")),
        .package(name: "GraphiQLVapor", url: "https://github.com/alexsteinerde/graphiql-vapor.git", .branch("vapor4"))
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                "GraphQLKit",
                "GraphiQLVapor"
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .target(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
