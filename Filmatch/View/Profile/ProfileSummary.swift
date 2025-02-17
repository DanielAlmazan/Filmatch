//
//  ProfileSummary.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 13/8/24.
//

import Kingfisher
import SwiftUI

struct ProfileSummary: View {
  let kRowsHeight: CGFloat = 90
  var user: FilmatchUser

  @State private var profileVm: ProfileViewModel
  
  init(
    user: FilmatchUser,
    filmatchRepository: FilmatchGoRepositoryImpl,
    filtersRepository: FiltersRepository
  ) {
    self.user = user
    self.profileVm = .init(
      user: user,
      filmatchRepository: filmatchRepository,
      filtersRepository: filtersRepository
    )
  }
  
  var body: some View {
    VStack(spacing: 10) {
      Group {
        // if let image = user.image {
        //   KFImage.url(image)
        //     .resizable()
        // } else {
        //   Image(systemName: "person.fill")
        //     .resizable()
        // }
      }
      .frame(width: 100, height: 100)
      .clipShape(Circle())
      .shadow(radius: 10)
      
      Text(user.email)
        .bold()
        .font(.headline)
      
      Spacer()
      
      Group {
        VStack(alignment: .leading) {
          Text("Platforms")
          Group {
            if self.profileVm.areProvidersLoading {
              ProgressView("Loading...")
            } else if let providers = profileVm.providers {
              ProvidersRow(providers: providers, maxWidth: 80)
            }
          }
          .frame(height: kRowsHeight)
        }
        
        // Neither superLike or watched are available right now
        // ProfileMediaCardRowContainer(
        //   title: "Super Liked",
        //   height: kRowsHeight,
        //   isLoading: self.$profileVm.areSuperLikedLoading,
        //   items: self.$profileVm.superLikedItems
        // )
        
        ProfileMediaCardRowContainer(
          title: "Liked",
          height: kRowsHeight,
          isLoading: self.$profileVm.areLikedLoading,
          items: self.$profileVm.likedItems
        )
        
        // ProfileMediaCardRowContainer(
        //   title: "Watched",
        //   height: kRowsHeight,
        //   isLoading: self.$profileVm.areWatchedLoading,
        //   items: self.$profileVm.watchedItems
        // )
        
        ProfileMediaCardRowContainer(
          title: "Disliked",
          height: kRowsHeight,
          isLoading: self.$profileVm.areDislikedLoading,
          items: self.$profileVm.dislikedItems
        )
      }
      .foregroundStyle(.onBgBase)
      .padding()
      .background(.bgContainer)
      .clipShape(.rect(cornerRadius: 10))
    }
    .scrollClipDisabled()
    .padding()
    .task {
      await self.profileVm.loadProviders()
      // await self.profileVm.loadSuperLikedItems()
      await self.profileVm.loadLikedItems()
      // await self.profileVm.loadWatchedItems()
      await self.profileVm.loadDislikedItems()
    }
  }
}

#Preview {
  @Previewable let filmatchRepository = FilmatchGoRepositoryImpl(
    datasource: FilmatchGoDatasourceImpl(
      client: FilmatchHttpClient()
    )
  )
  @Previewable let filtersRepository = FiltersRepositoryImpl(
    filtersDatasource: JsonFiltersDatasource()
  )
  
  ProfileSummary(
    user: .default,
    filmatchRepository: filmatchRepository,
    filtersRepository: filtersRepository
  )
}
