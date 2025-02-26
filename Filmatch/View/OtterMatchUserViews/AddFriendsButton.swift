//
//  AddFriendsButton.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 22/2/25.
//

import SwiftUI

struct AddFriendsButton: View {
  let size: CGFloat
  let onSubmit: () -> Void

  var body: some View {
    Button {
      onSubmit()
    } label: {
      VStack(alignment: .center) {
        Image(.addFriendsIcon)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxHeight: size * 0.8)
          .frame(height: size)
        
        Text("Add friends")
      }
      .frame(width: size)
    }
  }
}

#Preview {
  AddFriendsButton(size: 80) {
    print("Button tapped")
  }
}
