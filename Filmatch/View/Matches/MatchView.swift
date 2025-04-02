//
//  MatchView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 15/3/25.
//

import SwiftUI

struct MatchView: View {
  let match: Match
  
  var body: some View {
    GeometryReader { geometry in
      let availableHeight = geometry.size.height
      let computedCornerRadius = availableHeight / 20
      let computedMaxIconHeight = availableHeight * 0.2
      let computedOffset = computedMaxIconHeight * 0.2
      
      ZStack(alignment: .bottomTrailing) {
        PosterView(imageUrl: match.item.posterPath, size: .w500, posterType: .movie)
          .cornerRadius(computedCornerRadius)
        if match.isSuperMatch {
          Image(.superMatchIcon)
            .resizable()
            .scaledToFit()
            .frame(maxHeight: computedMaxIconHeight)
            .offset(x: computedOffset, y: computedOffset)
            .foregroundStyle(.yellow)
            .scrollClipDisabled()
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .aspectRatio(2/3, contentMode: .fit)
  }
}

#Preview {
  @Previewable @State var moviesRepository = MoviesRepositoryImpl(
    datasource: JsonMoviesRemoteDatasource()
  )
  HStack(alignment: .bottom) {
    MatchView(match: .movieMock)
    MatchView(match: .movieMock)
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
  .padding()
  .background(.bgBase)
  .environment(moviesRepository)
}
