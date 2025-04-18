//
//  ProfileMediaCardsRow.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 17/2/25.
//

import SwiftUI

struct ProfileMediaCardsRow: View {
  @Binding var items: [any DiscoverItem]?
  let cornerRadius: CGFloat
  let updateItem: (any DiscoverItem, InterestStatus?) -> Void

  var body: some View {
    if !(items?.isEmpty ?? true) {
      ScrollView(.horizontal) {
        HStack {
          ForEach(items!.prefix(20), id: \.id) { item in
            let statusBinding = Binding<InterestStatus?>(
              get: { item.status },
              set: { newStatus in
                guard let index = items!.firstIndex(where: { $0.id == item.id }) else { return }
                items![index].status = newStatus
                updateItem(item, newStatus)
              }
            )
            ZStack(alignment: .bottomTrailing) {
              PosterView(
                imageUrl: item.posterPath, size: .w342, posterType: .movie
              )
              .clipShape(.rect(cornerRadius: cornerRadius))
              .background(.ultraThinMaterial)
              .overlay(alignment: .topTrailing) {
                Menu {
                  InterestStatusPicker(selection: statusBinding)

                } label: {
                  Image(systemName: "ellipsis")
                    .rotationEffect(.init(degrees: 90))
                    .padding(.vertical, 10)
                    .shadow(color: .black, radius: 5)
                    .foregroundStyle(.white)
                }
              }
              .contextMenu {
                InterestStatusPicker(selection: statusBinding)
                  .onAppear {  }
              }

              if let status = item.status, let icon = status.icon {
                icon
                  .offset(x: 6, y: 6)
              }
            }
          }
        }
      }
      .scrollClipDisabled()
    }
  }
}

#Preview {
  @Previewable @State var movies: [any DiscoverItem]? = [DiscoverMovieItem.default]

  HStack {
    ProfileMediaCardsRow(items: $movies, cornerRadius: 10) { item, newStatus in
      print("Update item \(item) from status \(item.status ?? .pending) to status \(newStatus ?? .pending)")
    }
    .frame(height: 200)
    .task { movies![0].status = .watchlist }
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
}
