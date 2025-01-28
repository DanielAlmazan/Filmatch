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
            .frame(width: 200)
          }
        }
      }
      .scrollClipDisabled()
    } else {
      VStack {
        Text("No videos available.")
          .font(.title2)
        Text(
          "It might be related to the app's language, try selecting another one."
        )
        .font(.callout)
      }
      .multilineTextAlignment(.center)
    }
  }
}

#Preview {
  MovieVideosRowView(videos: [
    .init(
      id: "66d8ef23bcfa3188619d3755",
      iso_639_1: "en",
      iso_3166_1: "US",
      name: "Terror Reveal",
      key: "A8CMggxPlcc",
      site: "YouTube",
      size: 1080,
      type: "Teaser",
      official: true,
      publishedAt: "2024-09-04T08:00:11.000Z"),
    .init(
      id: "66d4fc654e19e170f3300625",
      iso_639_1: "en",
      iso_3166_1: "US",
      name: "Acid",
      key: "u3Pc92BFbOg",
      site: "YouTube",
      size: 1080,
      type: "Teaser",
      official: true,
      publishedAt: "2024-08-30T04:00:42.000Z"),
    .init(
      id: "66d4fc7f7aa5a87f371807ce",
      iso_639_1: "en",
      iso_3166_1: "US",
      name: "Scene Breakdown With Fede Álvarez Part 3",
      key: "Fhq3hIY0FkE",
      site: "YouTube",
      size: 1080,
      type: "Featurette",
      official: true,
      publishedAt: "2024-08-29T21:58:45.000Z"),
    .init(
      id: "66d4fc90ea22ad562c9479b9",
      iso_639_1: "en",
      iso_3166_1: "US",
      name: "Scene Breakdown With Fede Álvarez Part 2",
      key: "3hYa8gNVREE",
      site: "YouTube",
      size: 1080,
      type: "Featurette",
      official: true,
      publishedAt: "2024-08-29T20:02:16.000Z"),
    .init(
      id: "66d4fc9d3e1ab45ce5b18fc8",
      iso_639_1: "en",
      iso_3166_1: "US",
      name: "Scene Breakdown With Fede Álvarez Part 1",
      key: "HNkR2H5dhFw",
      site: "YouTube",
      size: 1080,
      type: "Featurette",
      official: true,
      publishedAt: "2024-08-29T17:34:29.000Z"),
    .init(
      id: "66d4fcabdf09d745b5a6b91a",
      iso_639_1: "en",
      iso_3166_1: "US",
      name: "Properly Scary",
      key: "NN5H68wIsak",
      site: "YouTube",
      size: 1080,
      type: "Teaser",
      official: true,
      publishedAt: "2024-08-28T22:13:09.000Z"),
    .init(
      id: "66d4fcb40f88a44bf9cb59c0",
      iso_639_1: "en",
      iso_3166_1: "US",
      name: "Now Playing In Theaters",
      key: "5ulVRDlX6gU",
      site: "YouTube",
      size: 1080,
      type: "Teaser",
      official: true,
      publishedAt: "2024-08-28T20:49:08.000Z"),
    .init(
      id: "66d4fcbca6965075d0cb58f7",
      iso_639_1: "en",
      iso_3166_1: "US",
      name: "Now Playing In Theaters",
      key: "D2veWoCsnWk",
      site: "YouTube",
      size: 1080,
      type: "Teaser",
      official: true,
      publishedAt: "2024-08-28T20:24:16.000Z"),
    .init(
      id: "66d4fcc7f459fa77e503fc1f",
      iso_639_1: "en",
      iso_3166_1: "US",
      name: "Alien: Romulus NYC",
      key: "2ERMUUB2uGY",
      site: "YouTube",
      size: 1080,
      type: "Featurette",
      official: true,
      publishedAt: "2024-08-28T19:06:57.000Z"),
  ])
}
