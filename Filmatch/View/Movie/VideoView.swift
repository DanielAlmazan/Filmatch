//
//  VideoView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 20/8/24.
//

import SwiftUI

struct VideoView: View {
    let video: Video
    let baseBackgroundImage = "https://i.ytimg.com/vi"
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: "\(baseBackgroundImage)/\(video.key)/hqdefault.jpg")) { phase in
                switch phase {
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                default:
                    Color.gray
                    ProgressView()
                }
            }
//            .frame(width: 300)
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
