//
//  AverageVotesCircleView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 6/9/24.
//

import SwiftUI

struct VotesAverageCircleView: View {
  let averageVotes: Double
  let font: Font
  var lineWidth: Double
  var lowAverageRange: ClosedRange<Double>
  var mediumAverageRange: ClosedRange<Double>
  var highAverageRange: ClosedRange<Double>
  
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
    lineWidth: Double = 30,
    lowAverage: ClosedRange<Double> = 0...0.35,
    highAverage: ClosedRange<Double> = 0.701...1,
    font: Font = .footnote
  ) {
    self.averageVotes = averageVotes
    self.lineWidth = lineWidth
    self.lowAverageRange = lowAverage
    self.highAverageRange = highAverage
    self.mediumAverageRange = lowAverage.upperBound...highAverage.lowerBound
    self.font = font
  }
  
  var body: some View {
    ZStack {
      Circle()
        .stroke(.black.opacity(0.5), lineWidth: self.lineWidth)
      Circle()
        .trim(from: 0, to: averageVotes)
        .stroke(self.color, style: StrokeStyle(lineWidth: self.lineWidth, lineCap: .round))
        .rotationEffect(.degrees(-90))
      
      HStack(spacing: 0) {
        Text("\(String(format:"%.0f", averageVotes * 100))%")
          .font(font)
      }
    }
  }
}

#Preview{
  VotesAverageCircleView(averageVotes: 0.67)
}
