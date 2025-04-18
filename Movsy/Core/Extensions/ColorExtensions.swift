//
//  ColorExtensions.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 30/12/24.
//

import SwiftUI
import UIKit

extension Color {
  /// Returns a new `Color` lightened by the given percentage (0% to 100%).
  ///
  /// - Parameter percentage: The percentage by which to lighten, e.g. `0.1` = 10%.
  /// - Returns: A new `Color` instance, lightened by the given percentage.
  func lighten(by percentage: CGFloat) -> Color {
    adjustBrightness(by: abs(percentage))
  }
  
  /// Returns a new `Color` darkened by the given percentage (0% to 100%).
  ///
  /// - Parameter percentage: The percentage by which to darken, e.g. `0.1` = 10%.
  /// - Returns: A new `Color` instance, darkened by the given percentage.
  func darken(by percentage: CGFloat) -> Color {
    adjustBrightness(by: -abs(percentage))
  }
  
  /// Internal helper to modify brightness in HSB color space.
  private func adjustBrightness(by amount: CGFloat) -> Color {
    // Convert Color -> UIColor
    guard let uiColor = UIColor(self).cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
      .map(UIColor.init)
    else {
      // Fallback: if conversion fails, return self
      return self
    }
    
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0
    
    // Extract HSB from the UIColor
    if uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
      // Modify brightness by the given amount (e.g. +0.1 or -0.1)
      brightness = max(min(brightness + (brightness * amount), 1), 0)
      
      // Create a new UIColor from the adjusted HSB
      let adjusted = UIColor(hue: hue,
                             saturation: saturation,
                             brightness: brightness,
                             alpha: alpha)
      return Color(adjusted)
    }
    
    return self
  }
}
