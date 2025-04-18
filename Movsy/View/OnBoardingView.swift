//
//  OnBoardingView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 3/10/24.
//

import SwiftUI

struct OnBoardingView: View {
  @AppStorage("isOnboarding") var isOnboarding: Bool?
  @Environment(\.locale) var locale
  @State private var selectedPage = 0

  private var totalPages: Int { onboardingImageNames.count }

  private var onboardingImageNames: [String] {
    let languagePrefix = locale.language.languageCode?.identifier == "es" ? "es" : "en"
    return (1...4).map { "onboarding-\(languagePrefix)-\($0)" }
  }

  var body: some View {
    ZStack(alignment: .bottom) {
      TabView(selection: $selectedPage) {
        ForEach(Array(onboardingImageNames.enumerated()), id: \.offset) { index, name in
          GeometryReader { proxy in
            Image(name)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: proxy.size.width, height: proxy.size.height)
              .clipped()
              .tag(index)
          }
          .ignoresSafeArea()
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .always))
      .ignoresSafeArea(.all)

      StartButtonView(
        isLastPage: selectedPage == totalPages - 1,
        action: {
          if selectedPage == totalPages - 1 {
            isOnboarding = false
          } else {
            withAnimation {
              selectedPage = totalPages - 1
            }
          }
        }
      )
      .padding(.top, 24)
    }
    .animation(.easeInOut, value: selectedPage)
    .background(Gradient(colors: [.accent, .accentDarker]))
  }
}

#Preview {
    OnBoardingView()
}
