//
//  PosterView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 12/8/24.
//

import SwiftUI

struct PosterView: View {
    let imageUrl: String
    let size: String
    
    var body: some View {
        AsyncImage(url: URL(string: "https://media.themoviedb.org/t/p/\(size)/\(imageUrl)")) { phase in
            switch phase {
            case .failure:
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .aspectRatio(2/3, contentMode: .fit)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(2/3, contentMode: .fit)
                    .frame(maxWidth: .infinity)
            default:
                Color.gray
                ProgressView()
            }
        }
    }
}

#Preview {
    PosterView(
        imageUrl: "1m3W6cpgwuIyjtg5nSnPx7yFkXW.jpg",
        size: "original"
    )
}
