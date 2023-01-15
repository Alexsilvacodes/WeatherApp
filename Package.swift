// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "WeatherApp",
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.1")),
        .package(url: "https://github.com/mac-cain13/R.swift.git", from: "7.0.0"),
        .package(url: "https://github.com/ashleymills/Reachability.swift.git", from: "5.0.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "WeatherApp",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "RswiftLibrary", package: "R.swift"),
                .product(name: "Reachability", package: "Reachability.swift"),
                .product(name: "SDWebImage", package: "SDWebImage"),
            ],
            plugins: [.plugin(name: "RswiftGeneratePublicResources", package: "R.swift")]
        ),
    ]
)
