//
//  VideoView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 20/8/24.
//

import SwiftUI

/// `VideoView` displays a video thumbnail with a play icon overlay.
struct VideoView: View {
  /// Takes a `Video` object and constructs a URL for the thumbnail image.
  let video: Video

  /// Used with `AsyncImage` to load the thumbnail.
  let baseBackgroundImage = "https://i.ytimg.com/vi"

  var body: some View {
    ZStack {
      AsyncImage(
        url: URL(string: "\(baseBackgroundImage)/\(video.key)/hqdefault.jpg")
      ) { phase in
        switch phase {
        case .failure:
          Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(height: 120)
        case .success(let image):
          image
            .resizable()
            .shadow(radius: 10)
            .aspectRatio(contentMode: .fit)

        default:
          Color.gray
          ProgressView()
        }
      }
      .cornerRadius(15)

      Image(systemName: "play.circle.fill")
        .resizable()
        .frame(width: 50, height: 50)
        .background(Color.black.opacity(0.7))
        .foregroundColor(.white)
        .clipShape(Circle())
    }
  }
}

#Preview {
  VideoView(video: .default)
}
