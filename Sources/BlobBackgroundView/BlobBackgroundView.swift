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

  public func makeCoordinator() -> Coordinator {
    Coordinator(animatedUpdates: animatedUpdates)
  }

  public func makeUIView(context: Context) -> BlobBackgroundUIView {
    BlobBackgroundUIView(configuration: configuration)
  }

  public func updateUIView(_ uiView: BlobBackgroundUIView, context: Context) {
    let configurationChanged = uiView.configuration != configuration
    let animatedUpdatesChanged = context.coordinator.animatedUpdates != animatedUpdates
    context.coordinator.animatedUpdates = animatedUpdates

    guard configurationChanged || animatedUpdatesChanged else {
      return
    }

    uiView.apply(configuration, animated: animatedUpdates)
  }

  public final class Coordinator {
    var animatedUpdates: Bool

    init(animatedUpdates: Bool) {
      self.animatedUpdates = animatedUpdates
    }
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
      .blobBackgroundIgnoringSafeArea(edges)
    )
  }
}

private extension View {
  @ViewBuilder
  func blobBackgroundIgnoringSafeArea(_ edges: Edge.Set) -> some View {
    if #available(iOS 14.0, tvOS 14.0, *) {
      ignoresSafeArea(edges: edges)
    } else {
      edgesIgnoringSafeArea(edges)
    }
  }
}
#endif
