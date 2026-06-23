# BlobBackgroundView

Animated UIKit and SwiftUI blob backgrounds for iOS apps.

## Installation

Add the package in Xcode:

```text
https://github.com/swift-man/BlobBackgroundView
```

## Documentation

DocC documentation is deployed to:

```text
https://docs.gorani.me/BlobBackgroundView/documentation/blobbackgroundview/
```

## SwiftUI

```swift
import BlobBackgroundView
import SwiftUI

struct HomeView: View {
  var body: some View {
    ZStack {
      BlobBackgroundView(configuration: .idle)
        .ignoresSafeArea()

      Text("Hello")
        .foregroundStyle(.white)
    }
  }
}
```

You can also use the convenience modifier:

```swift
content
  .blobBackground(.success)
```

## UIKit

```swift
import BlobBackgroundView
import UIKit

let backgroundView = BlobBackgroundUIView(configuration: .idle)
backgroundView.translatesAutoresizingMaskIntoConstraints = false
view.insertSubview(backgroundView, at: 0)

NSLayoutConstraint.activate([
  backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
  backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
  backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
  backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
])

backgroundView.apply(.success, animated: true)
```

## Custom Theme

```swift
let theme = BlobBackgroundTheme(
  surfaceTop: UIColor(red: 0.03, green: 0.07, blue: 0.12, alpha: 1),
  surfaceBottom: UIColor(red: 0.08, green: 0.05, blue: 0.18, alpha: 1),
  primary: .systemBlue,
  secondary: .systemPink,
  accent: .systemYellow
)

let configuration = BlobBackgroundConfiguration(
  theme: theme,
  intensity: 1.1,
  blobCount: 10,
  blobScale: 1.2,
  positionDrift: 0.7,
  jellyStrength: 0.5
)
```

`BlobBackgroundUIView` automatically pauses pulse animations when the view leaves a window and respects Reduce Motion.
