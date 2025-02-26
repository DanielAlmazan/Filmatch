//
//  MovieFirstDetailsRow.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 17/1/25.
//

import SwiftUI

struct MovieFirstDetailsRow: View {
  let voteAverage: Double
  let genres: [Genre]
  let runtime: Int?
  let providers: WatchProvidersResponse?
  
  @State var showProviders: Bool = false

  var body: some View {
    HStack {
      // MARK: - Average vote
      VotesAverageCircleView(averageVotes: voteAverage)

      // MARK: - Genres
      if !genres.isEmpty {
        Text(Utilities.parseNamesList(genres.map { $0.name ?? "nil" }))
          .font(.subheadline)
      }

      Spacer()

      Button {
        showProviders = true
      } label: {
        Text("Watch on...")
          .font(.caption)
      }
      .buttonStyle(.bordered)
      .disabled(providers?.isEmpty ?? true)
      .sheet(isPresented: $showProviders) {
        if let providers = providers {
          ProvidersView(providers: providers)
        }
      }

      // MARK: - Runtime
      Image(systemName: "clock")
      Text(minutesToHoursAndMinutes(minutes: runtime))
        .font(.footnote)
    }
  }
  /// Converts minutes into a formatted string of hours and minutes.
  /// - Parameter minutes: The total minutes to convert.
  /// - Returns: A formatted string representing hours and minutes (e.g., "2h 15m").
  private func minutesToHoursAndMinutes(minutes: Int?) -> LocalizedStringResource {
    guard let minutes else { return "Unknown" }
    return minutes == 0 ? "Unknown" : "\(minutes / 60)h \(minutes % 60)m"
  }
}

#Preview {
  MovieFirstDetailsRow(voteAverage: 0.5,
                       genres: [
                        .init(id: 0, name: "action"),
                        .init(id: 1, name: "comedy")
                       ],
                       runtime: 120,
                       providers: .default)
}
