//
//  MovieCastRowView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 25/8/24.
//

import SwiftUI

struct MovieCastRowView: View {
    let cast: [CastMember]?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            if let cast = cast {
                HStack(spacing: 16) {
                    ForEach(cast) { castMember in
                        MovieCastMemberView(castMember: castMember)
                            .padding(.vertical)
                    }
                }
            }
        }
    }
}

#Preview {
//    let castMemberWithNilProfilePhoto: CastMember = CastMember(id: CastMember.default.id, adult: CastMember.default.adult, gender: CastMember.default.gender, knownForDepartment: CastMember.default.knownForDepartment, name: CastMember.default.name, originalName: CastMember.default.originalName, popularity: CastMember.default.popularity, profilePath: nil, castId: CastMember.default.castId, character: CastMember.default.character, creditId: CastMember.default.creditId, order: CastMember.default.order)
    
    return MovieCastRowView(cast: [.default, .default, .default, .default])
}
