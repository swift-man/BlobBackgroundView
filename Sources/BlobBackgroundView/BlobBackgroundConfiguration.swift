import UIKit

public struct BlobBackgroundConfiguration: Equatable {
  public var animationSpeed: Double
  public var blobCount: Int
  public var blobScale: Double
  public var intensity: Double
  public var jellyStrength: Double
  public var positionDrift: Double
  public var theme: BlobBackgroundTheme

  public init(
    theme: BlobBackgroundTheme = .aurora,
    intensity: Double = 0.96,
    blobCount: Int = 8,
    blobScale: Double = 1.08,
    positionDrift: Double = 0.48,
    jellyStrength: Double = 0.36,
    animationSpeed: Double = 1
  ) {
    self.theme = theme
    self.intensity = intensity
    self.blobCount = blobCount
    self.blobScale = blobScale
    self.jellyStrength = jellyStrength
    self.positionDrift = positionDrift
    self.animationSpeed = animationSpeed
  }

  public static let idle = BlobBackgroundConfiguration(
    theme: .aurora,
    intensity: 0.96,
    blobCount: 8,
    blobScale: 1.08,
    positionDrift: 0.48,
    jellyStrength: 0.36
  )

  public static let countdown = BlobBackgroundConfiguration(
    theme: .sunrise,
    intensity: 1.08,
    blobCount: 10,
    blobScale: 1.3,
    positionDrift: 0.72,
    jellyStrength: 0.52
  )

  public static let success = BlobBackgroundConfiguration(
    theme: .success,
    intensity: 1.2,
    blobCount: 12,
    blobScale: 1.42,
    positionDrift: 0.86,
    jellyStrength: 0.62
  )
}

public struct BlobBackgroundTheme: Equatable {
  public var accent: UIColor
  public var primary: UIColor
  public var secondary: UIColor
  public var surfaceBottom: UIColor
  public var surfaceTop: UIColor

  public init(
    surfaceTop: UIColor,
    surfaceBottom: UIColor,
    primary: UIColor,
    secondary: UIColor,
    accent: UIColor
  ) {
    self.surfaceTop = surfaceTop
    self.surfaceBottom = surfaceBottom
    self.primary = primary
    self.secondary = secondary
    self.accent = accent
  }

  public static let aurora = BlobBackgroundTheme(
    surfaceTop: UIColor(red: 0.03, green: 0.07, blue: 0.12, alpha: 1),
    surfaceBottom: UIColor(red: 0.08, green: 0.05, blue: 0.18, alpha: 1),
    primary: UIColor(red: 0.22, green: 0.6, blue: 1, alpha: 1),
    secondary: UIColor(red: 1, green: 0.35, blue: 0.62, alpha: 1),
    accent: UIColor(red: 1, green: 0.72, blue: 0.22, alpha: 1)
  )

  public static let sunrise = BlobBackgroundTheme(
    surfaceTop: UIColor(red: 0.05, green: 0.08, blue: 0.13, alpha: 1),
    surfaceBottom: UIColor(red: 0.14, green: 0.08, blue: 0.02, alpha: 1),
    primary: UIColor(red: 0, green: 0.74, blue: 0.68, alpha: 1),
    secondary: UIColor(red: 1, green: 0.72, blue: 0.18, alpha: 1),
    accent: UIColor(red: 1, green: 0.38, blue: 0.56, alpha: 1)
  )

  public static let success = BlobBackgroundTheme(
    surfaceTop: UIColor(red: 0.04, green: 0.1, blue: 0.13, alpha: 1),
    surfaceBottom: UIColor(red: 0.12, green: 0.07, blue: 0.18, alpha: 1),
    primary: UIColor(red: 0.18, green: 0.82, blue: 0.66, alpha: 1),
    secondary: UIColor(red: 1, green: 0.42, blue: 0.72, alpha: 1),
    accent: UIColor(red: 1, green: 0.82, blue: 0.3, alpha: 1)
  )

  public static func == (lhs: BlobBackgroundTheme, rhs: BlobBackgroundTheme) -> Bool {
    lhs.surfaceTop.isEqual(rhs.surfaceTop) &&
      lhs.surfaceBottom.isEqual(rhs.surfaceBottom) &&
      lhs.primary.isEqual(rhs.primary) &&
      lhs.secondary.isEqual(rhs.secondary) &&
      lhs.accent.isEqual(rhs.accent)
  }
}
