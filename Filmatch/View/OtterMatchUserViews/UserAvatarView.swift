//
//  UserAvatarView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 21/2/25.
//

import Kingfisher
import SwiftUI

struct UserAvatarView: View {
  let user: OtterMatchUser?
  let size: CGFloat
  
  init(user: OtterMatchUser, size: CGFloat) {
    self.user = user
    self.size = size
  }
  
  @State private var didFail: Bool = false
  var url: URL? {
    if let user, let photoUrl = user.photoUrl {
      return URL(string: photoUrl)
    }
    return nil
  }
  
  var body: some View {
    if let user {
      if didFail || user.photoUrl == nil || user.photoUrl!.isEmpty, let username = user.username {
        Text(username.prefix(1).uppercased())
          .font(.title)
          .frame(width: size, height: size)
          .background(
            RadialGradient(
              gradient: Gradient(colors: [.accent, .accentDarker]),
              center: .center,
              startRadius: 10,
              endRadius: 50
            )
          )
          .clipShape(Circle())
        
      } else if let photoUrl = user.photoUrl {
        KFImage.url(URL(string: photoUrl))
          .placeholder {
            ProgressView("Loading...")
          }
          .onFailure{ error in
            print(error)
            didFail = true
          }
          .retry(maxCount: 3, interval: .seconds(5))
          .resizable()
          .clipShape(.circle)
          .aspectRatio(contentMode: .fill)
          .frame(width: size, height: size)
      }
    }
  }
}

#Preview {
  VStack {
    UserAvatarView(user: .default, size: 200)
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(.bgBase)
}
