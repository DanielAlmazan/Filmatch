//
//  MovieCardView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 27/8/24.
//

import SwiftUI

struct MovieCardView: View {
    let posterPath: String
    let title: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            PosterView(imageUrl: posterPath, size: "w500")
                .clipShape(.rect(cornerRadius: 20))

            Text(title)
                .font(.title3)
                .padding()
                .background(.white.opacity(0.5))
                .clipShape(.rect(cornerRadii: .init(
                    topLeading: 10,
                    topTrailing: 10
                )))
                .frame(maxWidth: 200)
                .lineLimit(1)
        }
    }
}

#Preview {
    MovieCardView(posterPath: "/b33nnKl1GSFbao4l3fZDDqsMx0F.jpg", title: "Alien: Romulus")
}
