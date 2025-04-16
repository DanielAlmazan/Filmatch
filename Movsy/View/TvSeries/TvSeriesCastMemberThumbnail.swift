//
//  TvSeriesCastMemberThumbnail.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 16/4/25.
//

import SwiftUI

struct TvSeriesCastMemberThumbnail: View {
  /// The `CastMember` object containing the cast member's information.
  let castMember: TvSeriesCastMember

  /// The width of the image displayed.
  let imageWidth: Double = 200

  /// The height of the image displayed.
  let imageHeight: Double = 300

  @Environment(PersonRepositoryImpl.self) var personRepository

  var body: some View {
    NavigationLink(destination: PersonDetailView(repository: personRepository, personId: castMember.id)) {
      VStack(alignment: .leading) {
        if let profilePath = castMember.profilePath {
          PosterView(imageUrl: profilePath, size: .w342, posterType: .person)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(radius: 5)
        } else {
          Image(systemName: "person.fill")
            .resizable()
            .padding()
            .scaledToFit()
            .frame(height: imageHeight, alignment: .center)
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(.black)
            )
            .shadow(radius: 5)
        }

        Text(castMember.name)
          .font(.headline)

        Text(castMember.roles.first?.character ?? "Unknown")
          .font(.caption)
      }
      .frame(width: imageWidth, alignment: .leading)
      .lineLimit(1)
    }
  }
}

#Preview {
  let personRepository = PersonRepositoryImpl(datasource: JsonPersonRemoteDatasource())

  TvSeriesCastMemberThumbnail(castMember: .default)
    .environment(personRepository)
}
