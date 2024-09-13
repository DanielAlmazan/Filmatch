//
//  MovieCastMemberView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/8/24.
//

import SwiftUI

struct MovieCastMemberView: View {
    let castMember: CastMember
    let imageWidth: Double = 200
    let imageHeight: Double = 300
    
    var body: some View {
        VStack(alignment: .leading) {
            if let profilePath = castMember.profilePath {
                PosterView(imageUrl: profilePath, size: "w200")
                    .clipShape(.rect(cornerRadius: 10))
                    .shadow(radius: 5)
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .padding()
                    .scaledToFit()
                    .frame(height: imageHeight, alignment: .center)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(.black))
                    .shadow(radius: 5)
            }
            
            Text(castMember.name)
                .font(.headline)
            
            Text(castMember.character)
                .font(.caption)
        }
        .frame(width: imageWidth, alignment: .leading)
        .lineLimit(1)
    }
}

#Preview {
    MovieCastMemberView(castMember: .default)
}
