//
//  VotesAverageCircleView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 6/9/24.
//

import SwiftUI

struct VotesAverageCircleView: View {
  let averageVotes: Double
  var lowAverageRange: Range<Double>
  var mediumAverageRange: Range<Double>
  var highAverageRange: Range<Double>

  var color: Color {
    switch Double(averageVotes) {
      case lowAverageRange:
        return .red

      case mediumAverageRange:
        return .orange

      case highAverageRange:
        return .green

      default:
        return .gray
    }
  }

  init(
    averageVotes: Double,
    lowAverageBound: Double = 0.4,
    highAverageBound: Double = 0.7
  ) {
    self.averageVotes = averageVotes
    self.lowAverageRange = 0..<lowAverageBound
    self.highAverageRange = highAverageBound..<1
    self.mediumAverageRange = lowAverageBound..<highAverageBound
  }

  var body: some View {
    Gauge(value: averageVotes, in: 0...1) {
    } currentValueLabel: {
      HStack(alignment: .top, spacing: 0) {
        Text("\(Int(averageVotes * 100))")
        Text("%", comment: "Percentage for the Average Votes gauge")
          .font(.caption2)
      }
      .padding(2)
      .foregroundStyle(.onBgBase)
    }
    .gaugeStyle(.accessoryCircularCapacity)
    .tint(color)
    .background(.bgBase)
  }
}

#Preview{
  VotesAverageCircleView(averageVotes: 0.7)
}
