//
//  TvSeriesCastRowView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 16/4/25.
//

import SwiftUI

struct TvSeriesCastRowView: View {
  let cast: [TvSeriesCastMember]

  var body: some View {
    if !cast.isEmpty {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 16) {
          ForEach(cast, id: \.id) { castMember in
            TvSeriesCastMemberThumbnail(castMember: castMember)
          }
        }
      }
      .scrollClipDisabled()
    } else {
      VStack {
        Text("No cast members found for this movie.")
      }
    }
  }
}

#Preview {
  let personRepository = PersonRepositoryImpl(datasource: JsonPersonRemoteDatasource())
  TvSeriesCastRowView(cast: [.default])
    .environment(personRepository)
}
