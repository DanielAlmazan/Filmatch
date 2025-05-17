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
      .indexViewStyle(.page(backgroundDisplayMode: .always))
      .tabViewStyle(.page(indexDisplayMode: .always))
      .ignoresSafeArea(.all)

      if selectedPage < totalPages - 1 {
        Button {
          selectedPage = totalPages - 1
        } label: {
          HStack {
            Text("Skip")
            Image(systemName: "forward.end.alt.fill")
          }
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 25)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
      }

      StartButtonView(
        isLastPage: selectedPage == totalPages - 1,
        action: {
          if selectedPage == totalPages - 1 {
            isOnboarding = false
          } else {
            withAnimation {
              selectedPage += 1
            }
          }
        }
      )
      .padding()
    }
    .animation(.easeInOut, value: selectedPage)
    .background(Gradient(colors: [.accent, .accentDarker]))
  }
}

#Preview {
    OnBoardingView()
}
