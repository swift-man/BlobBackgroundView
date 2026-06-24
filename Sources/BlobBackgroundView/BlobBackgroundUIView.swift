#if canImport(UIKit)
import UIKit

private final class NotificationObserverBag {
  private var observers: [NSObjectProtocol] = []

  func add(_ observer: NSObjectProtocol) {
    observers.append(observer)
  }

  deinit {
    observers.forEach(NotificationCenter.default.removeObserver)
  }
}

private enum BlobBackgroundAnimationKey {
  static let gradientColors = "blobBackgroundGradientColors"
  static let pulse = "blobBackgroundPulse"
  static let drift = "blobBackgroundDrift"
}

@MainActor
public final class BlobBackgroundUIView: UIView {
  private struct BlobSeed {
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let driftX: CGFloat
    let driftY: CGFloat
  }

  private let gradientLayer = CAGradientLayer()
  private var blobViews: [UIView] = []
  private var lastLayoutSize: CGSize = .zero
  private let notificationObservers = NotificationObserverBag()

  public private(set) var configuration: BlobBackgroundConfiguration

  private let seeds: [BlobSeed] = [
    BlobSeed(x: 0.12, y: 0.18, size: 0.36, driftX: 24, driftY: -18),
    BlobSeed(x: 0.82, y: 0.16, size: 0.42, driftX: -32, driftY: 26),
    BlobSeed(x: 0.58, y: 0.34, size: 0.3, driftX: 20, driftY: 34),
    BlobSeed(x: 0.22, y: 0.54, size: 0.4, driftX: 42, driftY: 12),
    BlobSeed(x: 0.78, y: 0.58, size: 0.34, driftX: -26, driftY: -36),
    BlobSeed(x: 0.42, y: 0.76, size: 0.46, driftX: 18, driftY: -22),
    BlobSeed(x: 0.9, y: 0.86, size: 0.3, driftX: -38, driftY: -18),
    BlobSeed(x: 0.08, y: 0.86, size: 0.32, driftX: 34, driftY: -30),
    BlobSeed(x: 0.5, y: 0.08, size: 0.26, driftX: -18, driftY: 28),
    BlobSeed(x: 0.7, y: 0.42, size: 0.28, driftX: 28, driftY: -24),
    BlobSeed(x: 0.3, y: 0.28, size: 0.25, driftX: -20, driftY: 26),
    BlobSeed(x: 0.54, y: 0.92, size: 0.34, driftX: 24, driftY: -34)
  ]

  public init(
    configuration: BlobBackgroundConfiguration = .idle,
    frame: CGRect = .zero
  ) {
    self.configuration = configuration
    super.init(frame: frame)
    configureView()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    if gradientLayer.frame != bounds {
      gradientLayer.frame = bounds
    }

    guard lastLayoutSize != bounds.size else {
      return
    }

    lastLayoutSize = bounds.size
    layoutBlobs(animated: false)
    refreshMotionAnimations()
  }

  public override func didMoveToWindow() {
    super.didMoveToWindow()
    refreshMotionAnimations()
  }

  public func apply(
    _ configuration: BlobBackgroundConfiguration,
    animated: Bool = true
  ) {
    let shouldRestartMotion = self.configuration != configuration

    if !shouldRestartMotion,
       gradientLayer.colors != nil,
       blobViews.count == clampedBlobCount(configuration.blobCount) {
      refreshMotionAnimations()
      return
    }

    self.configuration = configuration
    backgroundColor = configuration.theme.surfaceTop
    updateGradient(animated: animated)
    ensureBlobCount(configuration.blobCount)
    layoutBlobs(animated: animated)
    refreshMotionAnimations(forceRestart: shouldRestartMotion)
  }

  private func configureView() {
    isUserInteractionEnabled = false
    backgroundColor = configuration.theme.surfaceTop
    layer.insertSublayer(gradientLayer, at: 0)
    gradientLayer.startPoint = CGPoint(x: 0.18, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.82, y: 1)

    notificationObservers.add(NotificationCenter.default.addObserver(
      forName: UIAccessibility.reduceMotionStatusDidChangeNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      Task { @MainActor [weak self] in
        self?.refreshMotionAnimations()
      }
    })

    notificationObservers.add(NotificationCenter.default.addObserver(
      forName: UIApplication.willEnterForegroundNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      Task { @MainActor [weak self] in
        self?.refreshMotionAnimations(forceRestart: true)
      }
    })

    notificationObservers.add(NotificationCenter.default.addObserver(
      forName: UIApplication.didEnterBackgroundNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      Task { @MainActor [weak self] in
        self?.stopMotionAnimations()
      }
    })

    apply(configuration, animated: false)
  }

  private func ensureBlobCount(_ count: Int) {
    let targetCount = clampedBlobCount(count)

    while blobViews.count < targetCount {
      let blobView = UIView()
      blobView.isUserInteractionEnabled = false
      blobView.layer.cornerCurve = .continuous
      blobView.layer.masksToBounds = true
      addSubview(blobView)
      blobViews.append(blobView)
    }

    while blobViews.count > targetCount {
      blobViews.removeLast().removeFromSuperview()
    }
  }

  private func clampedBlobCount(_ count: Int) -> Int {
    max(0, min(count, BlobBackgroundConfiguration.maxBlobCount, seeds.count))
  }

  private func updateGradient(animated: Bool) {
    let nextColors = [
      configuration.theme.surfaceTop.cgColor,
      configuration.theme.surfaceBottom.cgColor
    ]

    guard !colorsEqual(gradientLayer.colors, nextColors) else {
      return
    }

    guard animated, gradientLayer.colors != nil, !UIAccessibility.isReduceMotionEnabled else {
      gradientLayer.colors = nextColors
      return
    }

    let animation = CABasicAnimation(keyPath: "colors")
    animation.fromValue = gradientLayer.colors
    animation.toValue = nextColors
    animation.duration = 0.42
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    gradientLayer.colors = nextColors
    gradientLayer.add(animation, forKey: BlobBackgroundAnimationKey.gradientColors)
  }

  private func layoutBlobs(animated: Bool) {
    guard !bounds.isEmpty else {
      return
    }

    for (index, blobView) in blobViews.enumerated() {
      let frame = frameForBlob(at: index)
      let color = colorForBlob(at: index)
      let alpha = CGFloat(configuration.intensity) * 0.3

      let changes = {
        blobView.bounds = CGRect(origin: .zero, size: frame.size)
        blobView.center = CGPoint(x: frame.midX, y: frame.midY)
        blobView.layer.cornerRadius = frame.width / 2
        blobView.backgroundColor = color.withAlphaComponent(alpha)
      }

      if animated, !UIAccessibility.isReduceMotionEnabled {
        UIView.animate(
          withDuration: 0.45,
          delay: 0,
          options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseInOut],
          animations: changes
        )
      } else {
        changes()
      }
    }
  }

  private func frameForBlob(at index: Int) -> CGRect {
    let seed = seeds[index % seeds.count]
    let shortSide = min(bounds.width, bounds.height)
    let scale = CGFloat(configuration.blobScale)
    let drift = CGFloat(configuration.positionDrift)
    let size = shortSide * seed.size * scale
    let center = CGPoint(
      x: bounds.width * seed.x + seed.driftX * drift,
      y: bounds.height * seed.y + seed.driftY * drift
    )

    return CGRect(
      x: center.x - size / 2,
      y: center.y - size / 2,
      width: size,
      height: size
    )
  }

  private func refreshMotionAnimations(forceRestart: Bool = false) {
    guard window != nil, !UIAccessibility.isReduceMotionEnabled else {
      stopMotionAnimations()
      return
    }

    for (index, blobView) in blobViews.enumerated() {
      if forceRestart {
        stopMotionAnimations(for: blobView)
      }

      if blobView.layer.animation(forKey: BlobBackgroundAnimationKey.pulse) == nil {
        startPulseAnimation(for: blobView, index: index)
      }

      if blobView.layer.animation(forKey: BlobBackgroundAnimationKey.drift) == nil {
        startDriftAnimation(for: blobView, index: index)
      }
    }
  }

  private func startPulseAnimation(for view: UIView, index: Int) {
    let strength = CGFloat(configuration.jellyStrength)
    guard strength > 0 else {
      return
    }

    let speed = configuration.animationSpeed
    let animation = CABasicAnimation(keyPath: "transform.scale")
    animation.fromValue = 1 - 0.06 * strength
    animation.toValue = 1 + 0.12 * strength + CGFloat(index % 3) * 0.025
    animation.duration = (3.4 + Double(index % 4) * 0.45) / speed
    animation.autoreverses = true
    animation.repeatCount = .infinity
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    view.layer.add(animation, forKey: BlobBackgroundAnimationKey.pulse)
  }

  private func startDriftAnimation(for view: UIView, index: Int) {
    let drift = CGFloat(configuration.positionDrift)
    guard drift > 0 else {
      return
    }

    let seed = seeds[index % seeds.count]
    let travelX = seed.driftX * drift
    let travelY = seed.driftY * drift
    guard hypot(travelX, travelY) > 0.5 else {
      return
    }

    let animation = CAKeyframeAnimation(keyPath: "position")
    animation.isAdditive = true
    animation.values = [
      CGPoint.zero,
      CGPoint(x: travelX * 0.42, y: travelY * 0.46),
      CGPoint(x: -travelY * 0.18, y: travelX * 0.18),
      CGPoint(x: -travelX * 0.3, y: -travelY * 0.36),
      CGPoint.zero
    ].map(NSValue.init(cgPoint:))
    animation.calculationMode = .cubicPaced
    animation.duration = (9.5 + Double(index % 5) * 1.35) / configuration.animationSpeed
    animation.repeatCount = .infinity
    view.layer.add(animation, forKey: BlobBackgroundAnimationKey.drift)
  }

  private func stopMotionAnimations() {
    blobViews.forEach(stopMotionAnimations(for:))
  }

  private func stopMotionAnimations(for view: UIView) {
    view.layer.removeAnimation(forKey: BlobBackgroundAnimationKey.pulse)
    view.layer.removeAnimation(forKey: BlobBackgroundAnimationKey.drift)
  }

  private func colorForBlob(at index: Int) -> UIColor {
    switch index % 3 {
    case 0:
      return configuration.theme.primary
    case 1:
      return configuration.theme.secondary
    default:
      return configuration.theme.accent
    }
  }
}

private func colorsEqual(_ lhs: [Any]?, _ rhs: [CGColor]) -> Bool {
  guard let lhs = lhs as? [CGColor], lhs.count == rhs.count else {
    return false
  }

  return zip(lhs, rhs).allSatisfy { left, right in
    left == right
  }
}
#endif
