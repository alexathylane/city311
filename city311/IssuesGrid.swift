//
//  IssuesGrid.swift
//  city311
//
//  Created by Alexandria Rohn on 10/22/23.
//

import SwiftUI

struct IssuesGrid: View {
  let symbols = Issues.allCases
  let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
  
  var body: some View {
    Text("Select your issue below...")
      .multilineTextAlignment(.center)
      .lineLimit(nil)
      .font(.title2)
    
    LazyVGrid(columns: self.columns, spacing: 0) {
      ForEach(self.symbols) { symbol in
        VStack {
          Image(systemName: symbol.symbolName)
            .font(.largeTitle)
            .padding(.bottom, 4)
          Text(symbol.shortText)
            .font(.footnote)
        }
        .padding()
      }
    }
  }
}

enum Issues: CaseIterable, Identifiable {
  var id: Issues { self }
  
  case accessibility, collision, sanitation, noise, road, vehicular, animal, miscellaneous
  
  var symbolName: String {
    switch self {
      case .accessibility: return "accessibility"
      case .collision: return "car.side.rear.and.collision.and.car.side.front"
      case .sanitation: return "trash"
      case .noise: return "ear.trianglebadge.exclamationmark"
      case .road: return "road.lanes"
      case .vehicular: return "car"
      case .animal: return "cat"
      case .miscellaneous: return "ellipsis.circle"
    }
  }
  
  var shortText: String {
    switch self {
      case .accessibility: return "Accessibility"
      case .collision: return "Collision"
      case .sanitation: return "Sanitation"
      case .noise: return "Noise"
      case .road: return "Road"
      case .vehicular: return "Vehicular"
      case .animal: return "Animal"
      case .miscellaneous: return "Something else"
    }
  }
}
