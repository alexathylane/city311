//
//  ViewModel.swift
//  city311
//
//  Created by Alexandria Rohn on 10/22/23.
//

import Foundation

final class ViewModel: ObservableObject {
  @Published var issueId: Int?
  
  @MainActor func createIssue(_ issue: Issues) {
    APIClient.shared.createIssue(issue) { result in
      switch result {
        case .success(let issueId):
          self.issueId = issueId
        case .failure(let error):
          print(error)
      }
    }
  }
  
  func onSubmitMessage(_ text: String) {
    guard let issueId = self.issueId else { fatalError() }
    guard text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else { return }
    
    Task {
      try await APIClient.shared.createMessage(issueId: issueId, text: text)
    }
  }
  
}
