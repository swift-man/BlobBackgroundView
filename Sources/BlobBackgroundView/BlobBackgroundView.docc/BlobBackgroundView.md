# ``BlobBackgroundView``

Animated blob backgrounds for UIKit and SwiftUI apps.

## Overview

`BlobBackgroundView` provides a lightweight animated gradient background made of drifting color blobs. Use the SwiftUI ``BlobBackgroundView`` wrapper for SwiftUI screens, or use ``BlobBackgroundUIView`` directly in UIKit view hierarchies.

The package keeps app-specific state outside the module. Host apps choose a ``BlobBackgroundConfiguration`` and can update it as their screen state changes.

`BlobBackgroundConfiguration/blobCount` is clamped to ``BlobBackgroundConfiguration/maxBlobCount``. Pulse and drift animations pause when the view leaves a window, restart when the app returns to the foreground, and respect Reduce Motion.

Numeric configuration values are normalized to safe ranges. SwiftUI's `animatesTransitions` option controls transition animations for configuration updates; it does not disable the ongoing pulse or drift effects. Use Reduce Motion, set `jellyStrength` to `0`, or set `positionDrift` to `0` when the background should stay still.

## Topics

### SwiftUI

- ``BlobBackgroundView``

### UIKit

- ``BlobBackgroundUIView``

### Configuration

- ``BlobBackgroundConfiguration``
- ``BlobBackgroundTheme``
