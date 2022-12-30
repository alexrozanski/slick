//
//  SlickView.swift
//  
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

// Keep this struct internal -- expose a higher-level appearance API if configuratiojn is desired.
internal struct Appearance {
  static var `default` = Appearance(
    blurColors: true,
    opacity: 0.55,
    blurRadius: 29.4,
    horizontalInsets: 22.93,
    verticalInsets: 5.8
  )

  let blurColors: Bool
  let opacity: Double
  let blurRadius: Double
  let horizontalInsets: Double
  let verticalInsets: Double
}

public struct SlickView<Image>: View where Image: View {
  public typealias ImageViewBuilder = (_ nsImage: NSImage) -> Image

  private let imageColorExtractor = ImageColorExtractor()

  private let image: NSImage?
  private let appearance: Appearance
  private let imageView: ImageViewBuilder

  @State private var backgroundColors: [NSColor]?

  // Use key path to use default `debugInfoHolder` if we're not wrapped in a SlickDebugContainerView
  @Environment(\.debugInfoHolder) private var debugInfoHolder

  private var debugInfo: DebugInfo? = nil

  public init(_ image: NSImage?, @ViewBuilder imageView: @escaping ImageViewBuilder) {
    self.image = image
    self.appearance = .default
    self.imageView = imageView
  }

  init(_ image: NSImage?, appearance: Appearance, @ViewBuilder imageView: @escaping ImageViewBuilder) {
    self.image = image
    self.appearance = appearance
    self.imageView = imageView
  }

  @MainActor public var body: some View {
    if let image = image {
      imageView(image)
        .onAppear {
          var debugInfo: ImageColorExtractor.ExtractionDebugInfo?
          recalculateColors(from: image, debugInfo: &debugInfo)
          debugInfoHolder.debugInfo = debugInfo.map { DebugInfo(colorExtractionDebugInfo: $0) }
        }
        .onChange(of: image) { newImage in
          var debugInfo: ImageColorExtractor.ExtractionDebugInfo?
          recalculateColors(from: newImage, debugInfo: &debugInfo)
          debugInfoHolder.debugInfo = debugInfo.map { DebugInfo(colorExtractionDebugInfo: $0) }
        }
        .padding(.horizontal, appearance.horizontalInsets)
        .padding(.vertical, appearance.verticalInsets)
        .background(backgroundGradient)
    }
  }

  @ViewBuilder private var backgroundGradient: some View {
    if let backgroundColors = backgroundColors {
      Rectangle()
        .fill(AngularGradient(gradient: Gradient(
          colors: backgroundColors.map { Color(cgColor: $0.cgColor)}
        ), center: .center, angle: .degrees(225)))
        .opacity(appearance.blurColors ? appearance.opacity : 1)
        .blur(radius: appearance.blurColors ? appearance.blurRadius : 0)
        .blendMode(appearance.blurColors ? .multiply : .normal)
    }
  }

  private func recalculateColors(from image: NSImage, debugInfo: inout ImageColorExtractor.ExtractionDebugInfo?) {
    let colors = imageColorExtractor.extractColors(from: image, debugInfo: &debugInfo)
    var wrappedColors = colors
    colors.first.map { wrappedColors.append($0) }
    backgroundColors = wrappedColors
  }
}

fileprivate extension DebugInfo {
  convenience init(colorExtractionDebugInfo debugInfo: ImageColorExtractor.ExtractionDebugInfo) {
    var info = [Position: PositionInfo]()
    debugInfo.info.keys.forEach { angle in
      guard
        let (image, colors) = debugInfo.info[angle],
        let image = image
      else { return }

      info[Position(angle: angle)] = PositionInfo(image: image, colors: colors)
    }

    self.init(info: info)
  }
}