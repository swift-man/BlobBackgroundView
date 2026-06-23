#if canImport(SwiftUI) && canImport(UIKit)
import SwiftUI
import UIKit

public struct BlobBackgroundView: UIViewRepresentable {
  public var animatesTransitions: Bool
  public var configuration: BlobBackgroundConfiguration

  public init(
    configuration: BlobBackgroundConfiguration = .idle,
    animatesTransitions: Bool = true
  ) {
    self.configuration = configuration
    self.animatesTransitions = animatesTransitions
  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(animatesTransitions: animatesTransitions)
  }

  public func makeUIView(context: Context) -> BlobBackgroundUIView {
    BlobBackgroundUIView(configuration: configuration)
  }

  public func updateUIView(_ uiView: BlobBackgroundUIView, context: Context) {
    let configurationChanged = uiView.configuration != configuration
    let transitionsChanged = context.coordinator.animatesTransitions != animatesTransitions
    context.coordinator.animatesTransitions = animatesTransitions

    guard configurationChanged || transitionsChanged else {
      return
    }

    uiView.apply(configuration, animated: animatesTransitions)
  }

  public final class Coordinator {
    var animatesTransitions: Bool

    init(animatesTransitions: Bool) {
      self.animatesTransitions = animatesTransitions
    }
  }
}

public extension View {
  func blobBackground(
    _ configuration: BlobBackgroundConfiguration = .idle,
    animatesTransitions: Bool = true,
    ignoresSafeAreaEdges edges: Edge.Set = .all
  ) -> some View {
    background(
      BlobBackgroundView(
        configuration: configuration,
        animatesTransitions: animatesTransitions
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
