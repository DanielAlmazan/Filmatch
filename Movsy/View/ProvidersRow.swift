//
//  ProvidersRow.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 17/1/25.
//

import Kingfisher
import SwiftUI

struct ProvidersRow: View {
  let providers: [ProviderModel]
  let maxWidth: CGFloat
  let cornerRadius: CGFloat
  
  init(providers: [ProviderModel], maxWidth: CGFloat) {
    self.providers = providers
    self.maxWidth = maxWidth
    self.cornerRadius = maxWidth / 5
  }

  func url(_ path: String) -> URL? {
    guard let base = API.tmdbMediaBaseURL, !path.isEmpty else {
      return nil
    }
    return URL(string: "\(base)/original/\(path)")
  }

  var body: some View {
    ZStack {
      ScrollView(.horizontal) {
        HStack {
          ForEach(providers) { provider in
            Group {
              if let logo = provider.logoPath {
                KFImage.url(url(logo))
                  .resizable()
                  .aspectRatio(contentMode: .fit)
              }
            }
            .frame(maxWidth: maxWidth, maxHeight: maxWidth)
            .background(.accent)
            .clipShape(.rect(cornerRadius: cornerRadius))
            .overlay {
              RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(.accent, lineWidth: 2)
            }
          }
        }
      }
      .scrollClipDisabled()
    }
  }
}

#Preview {
  ProvidersRow(
    providers: [
      .init(
        providerId: 2,
        providerName: "Apple TV",
        logoPath: "/9ghgSC0MA082EL6HLCW3GalykFD.jpg",
        displayPriority: 5),
      .init(
        providerId: 35,
        providerName: "Rakuten TV",
        logoPath: "/bZvc9dXrXNly7cA0V4D9pR8yJwm.jpg",
        displayPriority: 7),
      .init(
        providerId: 10,
        providerName: "Amazon Video",
        logoPath: "/seGSXajazLMCKGB5hnRCidtjay1.jpg",
        displayPriority: 36),
      .init(
        providerId: 3,
        providerName: "Google Play Movies",
        logoPath: "/8z7rC8uIDaTM91X0ZfkRf04ydj2.jpg",
        displayPriority: 15),
      .init(
        providerId: 68,
        providerName: "Microsoft Store",
        logoPath: "/5vfrJQgNe9UnHVgVNAwZTy0Jo9o.jpg",
        displayPriority: 18),
    ],
    maxWidth: 80
  )
}
