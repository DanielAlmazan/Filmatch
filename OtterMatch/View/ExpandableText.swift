//
//  ExpandableText.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 15/1/25.
//

import SwiftUI

struct ExpandableText: View {
  @State private var expanded: Bool = false
  @State private var truncated: Bool = false
  private var text: String
  
  let lineLimit: Int
  
  init(_ text: String, lineLimit: Int) {
    self.text = text
    self.lineLimit = lineLimit
  }
  
  private var moreLessText: String {
    if !truncated {
      return ""
    } else {
      return self.expanded ? "read less" : " read more"
    }
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(text)
        .lineLimit(expanded ? nil : lineLimit)
        .background(
          Text(text).lineLimit(lineLimit)
            .background(GeometryReader { visibleTextGeometry in
              ZStack { //large size zstack to contain any size of text
                Text(self.text)
                  .background(GeometryReader { fullTextGeometry in
                    Color.clear.onAppear {
                      self.truncated = fullTextGeometry.size.height > visibleTextGeometry.size.height
                    }
                  })
              }
              .frame(height: .greatestFiniteMagnitude)
            })
            .hidden() //keep hidden
        )
      if truncated {
        Button(action: {
          withAnimation {
            expanded.toggle()
          }
        }, label: {
          Text(moreLessText)
        })
      }
    }
  }
}

#Preview {
  ExpandableText("This code was found in https://prafullkumar77.medium.com/swiftui-how-to-make-see-more-see-less-style-button-at-the-end-of-text-675f859c2c4f", lineLimit: 3)
}
