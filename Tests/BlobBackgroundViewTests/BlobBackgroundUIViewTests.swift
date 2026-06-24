import XCTest

#if canImport(UIKit)
import UIKit
@testable import BlobBackgroundView

@MainActor
final class BlobBackgroundUIViewTests: XCTestCase {
  func testMotionAnimationsStartAfterViewMovesIntoWindow() throws {
    try XCTSkipIf(UIAccessibility.isReduceMotionEnabled, "Reduce Motion disables blob motion animations.")

    let configuration = BlobBackgroundConfiguration(
      theme: .aurora,
      intensity: 1,
      blobCount: 4,
      blobScale: 1,
      positionDrift: 1,
      jellyStrength: 0.5,
      animationSpeed: 1
    )
    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 640))
    let view = BlobBackgroundUIView(configuration: configuration, frame: window.bounds)

    window.addSubview(view)
    window.isHidden = false
    view.layoutIfNeeded()

    XCTAssertEqual(view.subviews.count, configuration.blobCount)

    let firstBlobLayer = try XCTUnwrap(view.subviews.first?.layer)
    XCTAssertNotNil(firstBlobLayer.animation(forKey: "blobBackgroundPulse"))
    XCTAssertNotNil(firstBlobLayer.animation(forKey: "blobBackgroundDrift"))
  }

  func testDriftAnimationStopsWhenPositionDriftIsZero() throws {
    try XCTSkipIf(UIAccessibility.isReduceMotionEnabled, "Reduce Motion disables blob motion animations.")

    let movingConfiguration = BlobBackgroundConfiguration(
      blobCount: 3,
      positionDrift: 1,
      jellyStrength: 0.5
    )
    let staticConfiguration = BlobBackgroundConfiguration(
      blobCount: 3,
      positionDrift: 0,
      jellyStrength: 0.5
    )
    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 640))
    let view = BlobBackgroundUIView(configuration: movingConfiguration, frame: window.bounds)

    window.addSubview(view)
    window.isHidden = false
    view.layoutIfNeeded()

    let firstBlobLayer = try XCTUnwrap(view.subviews.first?.layer)
    XCTAssertNotNil(firstBlobLayer.animation(forKey: "blobBackgroundDrift"))

    view.apply(staticConfiguration, animated: false)

    XCTAssertNil(firstBlobLayer.animation(forKey: "blobBackgroundDrift"))
    XCTAssertNotNil(firstBlobLayer.animation(forKey: "blobBackgroundPulse"))
  }
}
#else
final class BlobBackgroundViewPlatformTests: XCTestCase {
  func testPackageCanLoadOnNonUIKitHosts() {
    XCTAssertTrue(true)
  }
}
#endif
