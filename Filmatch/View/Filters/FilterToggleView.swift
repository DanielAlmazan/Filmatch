//
//  FilterToggleView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 22/12/24.
//

import Kingfisher
import SwiftUI

struct FilterToggleView: View {
  @Environment(\.colorScheme) var colorScheme

  let text: String?
  let image: String?
  let action: () -> Void
  let defaultSize: CGFloat? = 80
  let size: CGFloat?
  let cornerRadius: CGFloat = 20
  let isActive: Bool

  var blendMode: BlendMode {
    if image != nil {
      .normal
    } else if colorScheme == .dark {
      .lighten
    } else {
      .darken
    }
  }

  var tint: Color {
    if colorScheme == .dark && isActive {
      .white
    } else if colorScheme == .light && isActive {
      .black
    } else {
      .accent
    }
  }

  var strokeColor: Color {
    isActive ? image != nil ? .white : .onBgBase : .accent
  }
  
  var shadowColor: Color {
    colorScheme == .dark ? .white : .accent
  }

  
  /// This initializer is used for the text
  ///
  /// - Parameters:
  ///   - text: the text to be presented
  ///   - isSquared: sets the size of the button in a 80x80 square
  ///   - isActive: used in a few computed variables for changing
  ///   some parameters and represent the item is selected
  ///   - action: a callback for when the button is tapped
  init(
    text: String?,
    isSquared: Bool = false,
    isActive: Bool = false,
    action: @escaping () -> Void
  ) {
    self.text = text
    self.image = nil
    self.size = isSquared ? defaultSize : nil
    self.isActive = isActive
    self.action = action
  }
  
  /// This initializer is used for filters with images such as providers
  /// - Parameters:
  ///   - image: the image to be presented
  ///   - isActive: used in a few computed variables for changing
  ///   some parameters and represent the item is selected
  ///   - action: a callback for when the button is tapped
  init(
    image: String?,
    isActive: Bool = false,
    action: @escaping () -> Void
  ) {
    self.image = image
    self.text = nil
    self.size = defaultSize
    self.isActive = isActive
    self.action = action
  }

  var body: some View {
    Button {
      action()
    } label: {
      ZStack {
        if let text {
          if let size {
            Text(text)
              .padding(.horizontal, 16)
              .padding(.vertical, 8)
              .frame(width: size, height: size)
              .fontWeight(.semibold)
          } else {
            Text(text)
              .padding(.horizontal, 16)
              .padding(.vertical, 8)
              .fontWeight(.semibold)
          }
        } else if let image {
          KFImage(
            URL(string: "\(AppConstants.tmdbMediaBase)/original/\(image)")
          )
          .resizable()
          .scaledToFit()
          .frame(width: size, height: size)
          .padding(1)
        }
      }
      .overlay {
        RoundedRectangle(cornerRadius: cornerRadius)
          .stroke(strokeColor, lineWidth: 2)
          .background(isActive ? .accent.opacity(0.4) : .clear)
          .blendMode(blendMode)
      }
      .cornerRadius(cornerRadius)
      .shadow(color: shadowColor, radius: image != nil && isActive ? 2.5 : 0)
      .tint(tint)
    }
  }
}

#Preview {
  @Previewable let netflixUrlImage = "pbpMk2JmcoNnQwx5JGpXngfoWtp.jpg"
  @Previewable let amazonUrlImage = "pvske1MyAoymrs5bguRfVqYiM9a.jpg"
  @Previewable @State var isFilterActive: Bool = false
  @Previewable @State var isAllActive: Bool = false
  @Previewable @State var isNetflixProviderActive: Bool = false
  @Previewable @State var isAmazonProviderActive: Bool = false

  Group {
    FilterToggleView(
      text: "Filter",
      isActive: isFilterActive
    ) {
      isFilterActive.toggle()
      print("Button pressed")
    }
    FilterToggleView(
      text: "All",
      isSquared: true,
      isActive: isAllActive
    ) {
      print("Button 'All' pressed")
      isAllActive.toggle()
    }
    FilterToggleView(
      image: netflixUrlImage,
      isActive: isNetflixProviderActive
    ) {
      isNetflixProviderActive.toggle()
      print("Button pressed")
    }
    FilterToggleView(
      image: amazonUrlImage,
      isActive: isAmazonProviderActive
    ) {
      isAmazonProviderActive.toggle()
      print("Button pressed")
    }
  }
}
