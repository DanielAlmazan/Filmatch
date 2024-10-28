//
//  OnBoardingView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 3/10/24.
//

import SwiftUI

struct OnBoardingView: View {
    var body: some View {
      VStack {
        TabView {
          ForEach(0..<5) { index in
            VStack {
              Image(systemName: "document.fill")
                .resizable()
                .scaledToFit()
              Text("Onboarding page \(index)")
            }
            .padding()
          }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        StartButtonView()
      }
      .background(Gradient(colors: [.purple, .purple.mix(with: .black, by: 0.25)]))
    }
}

#Preview {
    OnBoardingView()
}
