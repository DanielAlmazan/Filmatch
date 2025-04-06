//
//  ProfileMediaCardsRow.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 17/2/25.
//

import SwiftUI

struct ProfileMediaCardsRow: View {
  @Binding var items: [any DiscoverItem]?
  let cornerRadius: CGFloat
  let updateItem: (any DiscoverItem, InterestStatus?) -> Void

  @Environment(\.dismiss) private var dismiss

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
              .contextMenu {
                Picker("", selection: statusBinding) {
                  ForEach(InterestStatus.allCases.filter { $0 != .pending }) { status in
                    if let icon = status.icon {
                      icon
                        .background(status == item.status ? Color.gray.opacity(0.3) : Color.clear)
                        .clipShape(Circle())
                        .tag(status)
                    }
                  }
                }
                .pickerStyle(.palette)
              }
              .background(.ultraThinMaterial)

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
    .task { movies![0].status = .interested }
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
}
