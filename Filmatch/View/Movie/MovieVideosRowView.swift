//
//  MovieVideosRow.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 19/8/24.
//

import SwiftUI

struct MovieVideosRowView: View {
    let videos: [Video]?
    let baseVideoUrl = "https://www.youtube.com/watch?v="

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                if let movieVideos = videos {
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
                } else {
                    Text("No videos available")
                }
            }
        }
    }
}

#Preview {
    MovieVideosRowView(videos: nil)
}
