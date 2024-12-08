//
//  ProfileSummary.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 13/8/24.
//

import Kingfisher
import SwiftUI

struct ProfileSummary: View {
  var user: UserModel

  var body: some View {
    ScrollView {
      VStack(spacing: 10) {
        Group {
          if let image = user.image {
            KFImage.url(image)
              .resizable()
          } else {
            Image(systemName: "person.fill")
              .resizable()
          }
        }
        .frame(width: 100, height: 100)
        .clipShape(Circle())
        .shadow(radius: 10)

        Text(user.email)
          .bold()
          .font(.headline)
        
        Spacer()
        
        HStack {
          Text("")
        }
      }
    }
  }
}

#Preview {
  ProfileSummary(user: .default)
}
