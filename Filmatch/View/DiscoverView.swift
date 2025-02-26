//
//  DiscoverView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/8/24.
//

import CoreHaptics
import SwiftUI

struct DiscoverView: View {
  private enum ActiveSheet: Identifiable {
    case detail(item: any DiscoverItem)
    case filters

    var id: String {
      switch self {
      case .detail(let item): "detail-\(item.id)"
      case .filters: "filters"
      }
    }
  }

  let onItemRemoved: ((any DiscoverItem, InterestStatus) -> Void)?

  private let screenWidth: CGFloat = UIScreen.main.bounds.size.width
  private let initialSecondCardBlur: Double = 1.5
  private let initialThirdCardBlur: Double = 3
  private let acceptBound: Double = 150

  @State private var discoverVm: DiscoverViewModel
  @State private var filtersVm: FiltersViewModel

  private var firstCardStatus: InterestStatus {
    let interested = (acceptBound...).contains(firstCardOffset.width)
    let watched = (acceptBound...).contains(firstCardOffset.height)
    let superInterested = (...(-acceptBound)).contains(firstCardOffset.height)
    let declined = (...(-acceptBound)).contains(firstCardOffset.width)

    if interested && !watched && !superInterested { return .interested }
    if declined && !watched && !superInterested { return .notInterested }
    if watched && !interested && !declined { return .watched }
    if superInterested && !interested && !declined { return .superInterested }

    return .pending
  }

  private var tint: Color {
    switch firstCardStatus {
    case .interested: .green
    case .notInterested: .red
    case .watched: .white.opacity(0.5)
    case .superInterested: .purple
    case .pending: .clear
    }
  }

  private var firstCardRotation: Angle {
    .degrees(firstCardOffset.width / 30)
  }

  @State private var isLoading: Bool = true

  @State private var firstCardOffset: CGSize = .zero

  @State private var secondCardBlurRadius: Double = 1.5
  @State private var secondCardRotation: Angle = .degrees(-2)

  @State private var thirdCardBlurRadius: Double = 3
  @State private var thirdCardRotation: Angle = .degrees(2)

  @State private var activeSheet: ActiveSheet?

  @State private var engine: CHHapticEngine?

  init(
    moviesRepository: MoviesRepository,
    tvSeriesRepository: TvSeriesRepository,
    otterMatchRepository: OtterMatchGoRepository,
    filtersRepository: FiltersRepository,
    onItemRemoved: ((any DiscoverItem, InterestStatus) -> Void)?
  ) {
    self.discoverVm = DiscoverViewModel(
      moviesRepository: moviesRepository,
      tvSeriesRepository: tvSeriesRepository,
      otterMatchRepository: otterMatchRepository)
    self.filtersVm = FiltersViewModel(filtersRepository: filtersRepository)
    self.onItemRemoved = onItemRemoved
  }

  var body: some View {
    VStack {
      if self.isLoading {
        ProgressView("Loading...")
      } else if let itemsList = self.discoverVm.items {
        // MARK: - Cards Stack
        ZStack {
          // MARK: - Third Item
          if itemsList.count >= 3 {
            CardView(item: itemsList[2])
              .rotationEffect(thirdCardRotation)
              .id(itemsList[2].id)
              .blur(radius: thirdCardBlurRadius)
              .onAppear {
                withAnimation {
                  thirdCardRotation = randomRotation(
                    isEven: itemsList.count % 2 != 0)
                }
              }
          }

          // MARK: - Second Item
          if itemsList.count >= 2 {
            CardView(item: itemsList[1])
              .id(itemsList[1].id)
              .rotationEffect(secondCardRotation)
              .blur(radius: 1.5)
              .onAppear {
                withAnimation {
                  secondCardRotation = randomRotation(
                    isEven: itemsList.count % 2 == 0)
                }
              }
          }

          // MARK: - First Item
          if itemsList.count >= 1 {
            CardView(item: itemsList[0])
              .id(itemsList[0].id)
              .overlay {
                RoundedRectangle(cornerRadius: 20)
                  .fill(tint)
                  .blendMode(.hardLight)
              }
              .offset(firstCardOffset)
              .rotationEffect(firstCardRotation)
              .onTapGesture {
                activeSheet = .detail(item: itemsList[0])
              }
              .gesture(
                DragGesture()
                  .onChanged { gesture in
                    onGestureChanged(gesture: gesture)
                  }
                  .onEnded { _ in
                    onGestureEnded(item: itemsList[0])
                  }
              )
              .onAppear(perform: prepareHaptics)
              .onChange(of: firstCardStatus) { oldStatus, newStatus in
                triggerHapticFeedback(
                  oldStatus: oldStatus,
                  newStatus: newStatus
                )
              }
              .onReceive(
                NotificationCenter.default.publisher(
                  for: UIApplication.didBecomeActiveNotification)
              ) { _ in
                self.restartHapticEngine()
              }
          } else if !self.isLoading {
            // Show retry message
            VStack {
              Text("There are no items to show...")
                .font(.headline)
              Text("Try refreshing or changing your filters.")
                .font(.caption)
              Button {
                self.isLoading = true
                self.discoverItems()
              } label: {
                Image(systemName: "arrow.clockwise.circle.fill")
                  .font(.title)
              }
            }
          }
        }
        .padding()
        .navigationTitle(
          "Discover \(self.filtersVm.selectedMedia == .movie ? "Movies" : "TV Series")"
        )
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              activeSheet = .filters
            } label: {
              Text("Filters")
                .foregroundStyle(.onAccent)
                .padding()
                .background(.accent)
                .clipShape(.capsule)
            }
          }
        }

        // MARK: - Buttons
        if !itemsList.isEmpty {
          AcceptDeclineRowButtons(
            item: itemsList[0], screenWidth: screenWidth, onAccept: acceptItem,
            onDecline: declineItem
          )
          .animation(.bouncy, value: firstCardStatus)
          .disabled(firstCardStatus != .pending)
        }
      } else {
        Text("\(self.discoverVm.errorMessage ?? "Unexpected error")")
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onAppear {
      self.isLoading = true
      self.discoverItems()
      self.filtersVm.fetchFilters()
    }
    .sheet(item: $activeSheet) { sheet in
      switch sheet {
      // MARK: - Detail Sheet
      case .detail(let item):
        ZStack(alignment: .topTrailing) {
          switch item.mediaType {
          case .movie:
            MovieDetailView(
              repository: self.discoverVm.moviesRepository, movieId: item.id)
          case .tvSeries:
            TvSeriesDetailView(
              repository: self.discoverVm.tvSeriesRepository,
              seriesId: item.id)
          }
          DismissSheetButton(onDismissSheet: nil)
        }
      // MARK: - Filters Sheet
      case .filters:
        NavigationStack {
          FiltersView(filtersViewModel: filtersVm)
            .background(.thinMaterial)
            .toolbar {
              ToolbarItem(placement: .navigationBarLeading) {
                Button {
                  self.filtersVm.onCancelButtonTapped()
                  activeSheet = nil
                } label: {
                  Text("Cancel")
                    .foregroundStyle(.secondary)
                }
              }
              ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                  if self.filtersVm.filtersDidChange {
                    self.filtersVm.rearrangeFilters()
                    self.onFiltersChanged()
                  }

                  activeSheet = nil
                } label: {
                  Text("Done")
                    .foregroundStyle(.primary)
                }
              }
            }
        }
      }
    }
  }

  // MARK: - Aux Functions

  private func discoverItems() {
    Task {
      await self.discoverVm.discoverItems(
        for: self.filtersVm.selectedMedia,
        with: self.filtersVm.currentFilters
      )
      self.isLoading = false
    }
  }

  private func onFiltersChanged() {
    self.discoverVm.resetItems()
    self.isLoading = true
    self.discoverItems()
  }

  private func onGestureChanged(gesture: DragGesture.Value) {
    let multiplier = 1.35
    let offset = gesture.translation

    withAnimation {
      firstCardOffset = .init(
        width: offset.width * multiplier,
        height: offset.height * multiplier)
    }
  }

  private func onGestureEnded(item: (any DiscoverItem)) {
    let extraWidth: Double = 70

    switch firstCardStatus {
    case .interested:
      acceptItem(item: item, screenWidth: screenWidth + extraWidth)
    case .notInterested:
      declineItem(item: item, screenWidth: screenWidth + extraWidth)
    case .watched, .superInterested, .pending:
      withAnimation(.bouncy) { firstCardOffset = .zero }
    }
  }

  private func prepareHaptics() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
      return
    }

    do {
      engine = try CHHapticEngine()
      try engine?.start()
    } catch {
      print("Error initializing haptic engine: \(error.localizedDescription)")
    }
  }

  private func restartHapticEngine() {
    do {
      try engine?.start()
    } catch {
      print("Error restarting haptic engine: \(error.localizedDescription)")
    }
  }

  private func triggerHapticFeedback(
    oldStatus: InterestStatus,
    newStatus: InterestStatus
  ) {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
      return
    }

    let intensity: Float
    let sharpness: Float
    var numberOfPulses: Int = 1

    switch newStatus {
    case .interested:
      intensity = 0.6
      sharpness = 0.6
      numberOfPulses = 2
    case .superInterested:
      intensity = 0.5
      sharpness = 0.5
    case .notInterested:
      intensity = 0.4
      sharpness = 0.4
    case .watched:
      intensity = 0.3
      sharpness = 0.3
    case .pending:
      return
    }

    var events: [CHHapticEvent] = []
    for i in 0..<numberOfPulses {
      let event = CHHapticEvent(
        eventType: .hapticTransient,
        parameters: [
          CHHapticEventParameter(
            parameterID: .hapticIntensity, value: intensity),
          CHHapticEventParameter(
            parameterID: .hapticSharpness, value: sharpness),
        ],
        relativeTime: Double(i) * 0.05
      )
      events.append(event)
    }

    do {
      let pattern = try CHHapticPattern(events: events, parameters: [])
      let player = try engine?.makePlayer(with: pattern)
      try player?.start(atTime: 0)
    } catch {
      print("Error playing haptic feedback: \(error.localizedDescription)")
    }
  }

  private func randomRotation(isEven: Bool) -> Angle {
    let randomValue = Double.random(in: 1.5...3.5)

    return .degrees(isEven ? randomValue : randomValue * -1)
  }

  private func acceptItem(item: (any DiscoverItem), screenWidth: CGFloat) {
    guard let onItemRemoved else { return }

    onItemRemoved(item, .interested)
    print("Movie \(item.getTitle) accepted")
    removeCard(moveTo: screenWidth)
  }

  private func declineItem(item: (any DiscoverItem), screenWidth: CGFloat) {
    guard let onItemRemoved else { return }

    onItemRemoved(item, .notInterested)
    print("Movie \(item.getTitle) declined")
    removeCard(moveTo: -screenWidth)
  }

  /// Handles the process of the first card removal.
  ///
  /// - Parameters:
  ///  - offset: The offset to be moved. It is used for modifying the offset but also for rotating the card.
  private func removeCard(moveTo offset: Double) {
    let animationDuration = 0.3

    withAnimation(.easeInOut(duration: animationDuration)) {
      // Move the first card away from the view
      firstCardOffset.width = offset

      // Set the second card's rotation and blur to zero
      secondCardRotation = .zero
      secondCardBlurRadius = .zero
    } completion: {
      secondCardRotation = self.thirdCardRotation
      secondCardBlurRadius = self.initialSecondCardBlur

      // Remove the first movie and card from the lists
      self.discoverVm.items?.removeFirst()
      print("Items left: \(String(describing: self.discoverVm.items?.count))")
      onItemListChange()
    }
  }

  private func onItemListChange() {
    guard let items = discoverVm.items, !items.isEmpty else { return }

    // Reset properties for the next card
    firstCardOffset = .zero

    withAnimation {
      self.thirdCardRotation = self.randomRotation(
        isEven: items.count % 2 != 0)
    }

    // Fetch more items if necessary
    if items.count <= self.discoverVm.kLoadingThreshold && !isLoading {
      discoverItems()
    }
  }
}

#Preview {
  DiscoverView(
    moviesRepository: MoviesRepositoryImpl(
      datasource: JsonMoviesRemoteDatasource()
    ),
    tvSeriesRepository: TvSeriesRepositoryImpl(
      datasource: JsonTvSeriesDatasource()
    ),
    otterMatchRepository: OtterMatchGoRepositoryImpl(
      datasource: OtterMatchGoDatasourceImpl(client: OtterMatchHttpClient())),
    filtersRepository: FiltersRepositoryImpl(
      filtersDatasource: JsonFiltersDatasource()
    ),
    onItemRemoved: { item, status in print("\(item.getTitle) \(status.rawValue)") }
  )
  .environment(
    PersonRepositoryImpl(
      datasource: JsonPersonRemoteDatasource()
    )
  )
}
