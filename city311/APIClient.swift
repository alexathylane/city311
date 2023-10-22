//
//  APIClient.swift
//  city311
//
//  Created by Alexandria Rohn on 10/22/23.
//

import Foundation

import Foundation

class APIClient {
  static let shared = APIClient()
  
  init(userId: String = "abc123") {
    self.userId = userId
  }
  
  func createIssue(_ issue: Issues) async throws -> Int {
    // Construct the URL
    var urlComponents = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: true)
    urlComponents?.path = "/new_issue"
    urlComponents?.queryItems = [
      URLQueryItem(name: "user_id", value: userId),
      URLQueryItem(name: "issue_type", value: issue.rawValue)
    ]
    
    guard let url = urlComponents?.url else {
      throw URLError(.badURL)
    }
    
    // Create the URLRequest
    var request = URLRequest(url: url)
    request.httpMethod = "GET"  // Change to POST if necessary
    
    // Make the network request
    let (data, response) = try await URLSession.shared.data(for: request)
    
    // Check for a successful response
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw URLError(.badServerResponse)
    }
    
    // Decode the JSON response
    let responseObject = try self.decoder.decode(CreateIssueResponse.self, from: data)
    
    return responseObject.issueId
  }
  
  private let decoder = JSONDecoder()
  private let userId: String
  private let baseURL = URL(string: "http://ec2-34-227-206-199.compute-1.amazonaws.com")!
}

struct CreateIssueResponse: Decodable {
  let userId: String
  let issueId: Int
  let issueType: String
  
  enum CodingKeys: String, CodingKey {
    case userId = "user_id"
    case issueId = "issue_id"
    case issueType = "issue_type"
  }
}
