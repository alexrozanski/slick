# Aurora

[![Swift](https://img.shields.io/badge/Swift-5.x-orange?style=flat)](https://img.shields.io/badge/Swift-5.x-Orange?style=flat)
[![Platforms](https://img.shields.io/badge/Platforms-macOS-lightgrey?style=flat)](https://img.shields.io/badge/Platforms-macOS-lightgrey?style=flat)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat)

A SwiftUI View for displaying a soft, backlit background around images.

## Usage

Import `Aurora` into the file for your SwiftUI `View` which will use the Aurora view:

```swift
import Aurora
```

Create an `AuroraView`, passing the `NSImage` you want to display as the first parameter. `AuroraView` takes
a trailing closure which you should use to render the image as you see fit.

For example, to display an image named `"astronaut"` in your app bundle:

```swift
AuroraView(NSImage(named: "astronaut")) { nsImage in
  Image(nsImage: nsImage)
    .resizable()
    .aspectRatio(contentMode: .fit)
}
```

Which will render:

<img src="https://github.com/alexrozanski/Aurora/blob/main/docs/astronaut_example.png?raw=true" width="630" height="553">

### Debug View

Aurora allows you to render a debug view to show which parts of your image are being sampled and the colours which are being sampled from each section. To render the debug view, simply add a `AuroraDebugView` and wrap both in a `AuroraDebugContainerView`, for example:

```swift
AuroraDebugContainerView {
  HStack(alignment: .top) {
    AuroraView(NSImage(named: "astronaut")) { nsImage in
      Image(nsImage: nsImage)
        .resizable()
        .aspectRatio(contentMode: .fit)
    }
    AuroraDebugView()
  }
}
```

`AuroraDebugContainerView` is required to connect the `AuroraView` and `AuroraDebugView` together.

## Setup

### [Preferred] Swift Package Manager

Aurora is best installed using the [Swift Package Manager](https://www.swift.org/package-manager/). Add the following to your target's `dependencies` in `Package.swift`:

```swift
dependencies: [
    ...,
    .package(url: "https://github.com/alexrozanski/Aurora.git", .upToNextMajor(from: "1.0.0"))
]
```

Or add it as a dependency by specifying `https://github.com/alexrozanski/Aurora.git` through Xcode's Package Dependencies UI.

### Manual

- Clone the Slick repository:

```bash
git clone https://github.com/alexrozanski/Aurora.git # or git@github.com:alexrozanski/Aurora.git with SSH
```

- Open `Aurora.xcodeproj` in Xcode and build the `Aurora` target in Debug or Release mode (depending on how you will be using the framework).
- Open the products folder from Xcode using Product > Show Build Folder in Finder from the Xcode menu.
- Find `Aurora.framework` in either the `Debug` or `Release` folder (depending on how you built the framework).
- Drag `Aurora.framework` to the Project Navigator (sidebar) of your Xcode project, checking 'Copy items if needed' and checking the correct target that you want the framework to be added to.

## Sample App

The `SlickExample` app shows an example of Slick in action, with some sample images and info showing which sections of the image and which colours were sampled.

![SlickExample app](docs/example_app.png)

## Credits

- Atomic Object's [blog post](https://spin.atomicobject.com/2016/12/07/pixels-and-palettes-extracting-color-palettes-from-images/) on extracting colours from images was very helpful in implementing the image colour extraction logic in Aurora.
- Sample images generated using [Apple's runner](https://github.com/apple/ml-stable-diffusion) of Stable Diffusion on Apple Silicon.

## License

Slick is released under the MIT license. See [LICENSE](LICENSE) for more details.
