//
//  CastMemberThumbnailView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/8/24.
//

import SwiftUI

/// `MovieCastMemberView` displays information about a single cast member, including their profile image, name, and character.
/// When tapped, it navigates to the cast member's profile page.
struct CastMemberThumbnailView: View {
  /// The `CastMember` object containing the cast member's information.
  let castMember: CastMember

  /// The width of the image displayed.
  let imageWidth: Double = 200

  /// The height of the image displayed.
  let imageHeight: Double = 300
  
  @Environment(PersonRepositoryImpl.self) var personRepository

  var body: some View {
    NavigationLink(destination: PersonDetailView(repository: personRepository, personId: castMember.id)) {
      VStack(alignment: .leading) {
        if let profilePath = castMember.profilePath {
          PosterView(imageUrl: profilePath, size: "w200", posterType: .person)
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
        
        Text(castMember.character)
          .font(.caption)
      }
      .frame(width: imageWidth, alignment: .leading)
      .lineLimit(1)
    }
  }
}

#Preview {
  @Previewable @State var personRepository = PersonRepositoryImpl(datasource: PersonDatasourceImpl(client: TMDBHttpClient(urlBase: AppConstants.tmdbUrlBase)))

  NavigationStack {
    CastMemberThumbnailView(castMember: .default)
      .environment(personRepository)
  }
}
