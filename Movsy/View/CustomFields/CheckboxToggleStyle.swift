//
//  CheckboxToggleStyle.swift
//  Movsy
//
//  Code from https://www.kodeco.com/books/swiftui-cookbook/v1.0/chapters/2-create-a-checkbox-in-swiftui
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    HStack {
      configuration.label
      Image(systemName: configuration.isOn ? "checkmark.square" : "square")
        .resizable()
        .frame(width: 24, height: 24)
        .onTapGesture { configuration.isOn.toggle() }
    }
  }
}

#Preview {
  @Previewable @State var isTermsAccepted: Bool = false

  Toggle(isOn: $isTermsAccepted) {
    HStack(spacing: 4) {
      Text("I accept the")
      Link("Terms and Conditions", destination: URL(string: "https://catdevs.com/privacy-policy.html")!)
        .underline()
    }
    .font(.footnote)
  }
  .toggleStyle(CheckboxToggleStyle())
  .padding(.horizontal)
}
