//
//  IssuesGrid.swift
//  city311
//
//  Created by Alexandria Rohn on 10/22/23.
//

import SwiftUI

struct IssuesGrid: View {
  @ObservedObject var vm: ViewModel
  
  private let issues = Issues.allCases
  private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
  
  var body: some View {
    Text("Select your issue below...")
      .multilineTextAlignment(.center)
      .lineLimit(nil)
      .font(.title2)
    
    LazyVGrid(columns: self.columns, spacing: 0) {
      ForEach(self.issues) { issue in
        VStack {
          IssueButton(issue: issue) {
            self.vm.createIssue(issue)
          }
        }
        .padding()
      }
    }
  }
}

struct IssueButton: View {
  let issue: Issues
  let action: () -> Void
  
  var body: some View {
    Button(action: {
      self.action()
    }, label: {
      VStack(spacing: 6) {
        Image(systemName: issue.symbolName)
          .font(.title)
        Text(issue.shortText)
          .font(.caption)
      }
    })
  }
}

enum Issues: String, CaseIterable, Identifiable {
  
  var id: Issues { self }
  
  case accessibility, collision, sanitation, noise, road, vehicular, animal, other
  
  var symbolName: String {
    switch self {
      case .accessibility: return "accessibility"
      case .collision: return "car.side.rear.and.collision.and.car.side.front"
      case .sanitation: return "trash"
      case .noise: return "ear.trianglebadge.exclamationmark"
      case .road: return "road.lanes"
      case .vehicular: return "car"
      case .animal: return "cat"
      case .other: return "ellipsis.circle"
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
      case .other: return "Something else"
    }
  }
}
