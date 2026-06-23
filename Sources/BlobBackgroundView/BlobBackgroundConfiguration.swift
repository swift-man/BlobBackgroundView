#if canImport(UIKit)
import UIKit

public struct BlobBackgroundConfiguration: Equatable {
  /// The maximum number of blobs rendered by the built-in seed layout.
  ///
  /// Keep this value in sync with the seed list used by `BlobBackgroundUIView`.
  public static let maxBlobCount = 12

  public var animationSpeed: Double {
    didSet {
      animationSpeed = Self.normalized(animationSpeed, min: 0.2, max: 3, fallback: 1)
    }
  }

  /// Requested blob count. Values above ``maxBlobCount`` are clamped.
  public var blobCount: Int {
    didSet {
      blobCount = Self.normalizedBlobCount(blobCount)
    }
  }

  public var blobScale: Double {
    didSet {
      blobScale = Self.normalized(blobScale, min: 0.2, max: 3, fallback: 1)
    }
  }

  public var intensity: Double {
    didSet {
      intensity = Self.normalized(intensity, min: 0.2, max: 1.8, fallback: 1)
    }
  }

  public var jellyStrength: Double {
    didSet {
      jellyStrength = Self.normalized(jellyStrength, min: 0, max: 1.5, fallback: 0)
    }
  }

  public var positionDrift: Double {
    didSet {
      positionDrift = Self.normalized(positionDrift, min: 0, max: 1.5, fallback: 0)
    }
  }

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
    self.intensity = Self.normalized(intensity, min: 0.2, max: 1.8, fallback: 1)
    self.blobCount = Self.normalizedBlobCount(blobCount)
    self.blobScale = Self.normalized(blobScale, min: 0.2, max: 3, fallback: 1)
    self.jellyStrength = Self.normalized(jellyStrength, min: 0, max: 1.5, fallback: 0)
    self.positionDrift = Self.normalized(positionDrift, min: 0, max: 1.5, fallback: 0)
    self.animationSpeed = Self.normalized(animationSpeed, min: 0.2, max: 3, fallback: 1)
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

  private static func normalized(_ value: Double, min: Double, max: Double, fallback: Double) -> Double {
    guard value.isFinite else {
      return fallback
    }

    return Swift.max(min, Swift.min(max, value))
  }

  private static func normalizedBlobCount(_ value: Int) -> Int {
    Swift.max(0, Swift.min(value, maxBlobCount))
  }
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
}
#endif
