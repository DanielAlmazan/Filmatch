//
//  ProvidersRow.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 17/1/25.
//

import Kingfisher
import SwiftUI

struct ProvidersRow: View {
  let providers: [ProviderModel]
  let cornerRadius: CGFloat = 20

  func url(_ path: String) -> URL {
    URL(string: "\(AppConstants.mediaBase)/original/\(path)")!
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
              }
            }
            .frame(width: 80, height: 80)
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
    ]
  )
}
