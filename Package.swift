// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "BlobBackgroundView",
  platforms: [
    .iOS(.v13),
    .tvOS(.v13)
  ],
  products: [
    .library(
      name: "BlobBackgroundView",
      targets: ["BlobBackgroundView"]
    )
  ],
  targets: [
    .target(
      name: "BlobBackgroundView"
    )
  ]
)
