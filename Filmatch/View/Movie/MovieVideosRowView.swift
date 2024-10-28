//
//  MovieVideosRowView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 19/8/24.
//

import SwiftUI

/// `MovieVideosRowView` displays a horizontal scrollable row of videos for a movie.
/// It includes a `Link` to the youtube video.
struct MovieVideosRowView: View {
  /// An optional array of `Video` object representing the movie's videos.
  /// Depending on the selected app's language, there might not be any result.
  let videos: [Video]?
  
  let baseVideoUrl = "https://www.youtube.com/watch?v="

  var body: some View {
    if let movieVideos = videos, !movieVideos.isEmpty {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 16) {
          ForEach(movieVideos) { video in
            VStack(alignment: .leading) {
              Link(destination: URL(string: "\(baseVideoUrl)\(video.key)")!) {
                VideoView(video: video)
              }
              Text(video.name)
                .font(.headline)
                .lineLimit(1)
            }
            .frame(width: 250)
          }
        }
      }
    } else {
      VStack {
        Text("No videos available.")
          .font(.title2)
        Text("It might be related to the app's language, try selecting another one.")
          .font(.callout)
      }
      .multilineTextAlignment(.center)
    }
  }
}

#Preview {
  MovieVideosRowView(videos: nil)
}
