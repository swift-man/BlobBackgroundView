# ``BlobBackgroundView``

Animated blob backgrounds for UIKit and SwiftUI apps.

## Overview

`BlobBackgroundView` provides a lightweight animated gradient background made of drifting color blobs. Use the SwiftUI ``BlobBackgroundView`` wrapper for SwiftUI screens, or use ``BlobBackgroundUIView`` directly in UIKit view hierarchies.

The package keeps app-specific state outside the module. Host apps choose a ``BlobBackgroundConfiguration`` and can update it as their screen state changes.

`BlobBackgroundConfiguration/blobCount` is clamped to ``BlobBackgroundConfiguration/maxBlobCount``. Pulse animations pause when the view leaves a window, restart when the app returns to the foreground, and respect Reduce Motion.

## Topics

### SwiftUI

- ``BlobBackgroundView``

### UIKit

- ``BlobBackgroundUIView``

### Configuration

- ``BlobBackgroundConfiguration``
- ``BlobBackgroundTheme``
