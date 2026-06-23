#if canImport(SwiftUI)
import SwiftUI
import UIKit

public struct BlobBackgroundView: UIViewRepresentable {
  public var animatedUpdates: Bool
  public var configuration: BlobBackgroundConfiguration

  public init(
    configuration: BlobBackgroundConfiguration = .idle,
    animatedUpdates: Bool = true
  ) {
    self.configuration = configuration
    self.animatedUpdates = animatedUpdates
  }

  public func makeUIView(context: Context) -> BlobBackgroundUIView {
    BlobBackgroundUIView(configuration: configuration)
  }

  public func updateUIView(_ uiView: BlobBackgroundUIView, context: Context) {
    uiView.apply(configuration, animated: animatedUpdates)
  }
}

public extension View {
  func blobBackground(
    _ configuration: BlobBackgroundConfiguration = .idle,
    animatedUpdates: Bool = true,
    ignoresSafeAreaEdges edges: Edge.Set = .all
  ) -> some View {
    background(
      BlobBackgroundView(
        configuration: configuration,
        animatedUpdates: animatedUpdates
      )
      .edgesIgnoringSafeArea(edges)
    )
  }
}
#endif
