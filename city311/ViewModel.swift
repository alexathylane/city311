//
//  ViewModel.swift
//  city311
//
//  Created by Alexandria Rohn on 10/22/23.
//

import Foundation

final class ViewModel: ObservableObject {
  @Published var issueId: String?
  @Published var showChatSheet = false
  @Published var messages: [Message] = []
  @Published var isFetchingMessages = false
  
  @MainActor func createIssue(_ issue: IssueType) {
    APIClient.shared.createIssue(issue) { result in
      switch result {
        case .success(let issueId):
          self.issueId = issueId
          self.showChatSheet = true
        case .failure(let error):
          print(error)
      }
    }
  }
  
  @MainActor func onSubmitMessage(_ text: String) {
    guard let issueId = self.issueId else { fatalError() }
    guard text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else { return }
    
    self.isFetchingMessages = true
    
    APIClient.shared.createMessage(issueId: issueId, text: text) { result in
      self.isFetchingMessages = false
      switch result {
        case.success(let messages):
          self.messages = messages
        case .failure(let error):
          print(error)
      }
    }
  }
  
}
