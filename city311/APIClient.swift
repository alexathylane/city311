//
//  APIClient.swift
//  city311
//
//  Created by Alexandria Rohn on 10/22/23.
//

import Foundation

import Foundation

@MainActor
class APIClient {
  static let shared = APIClient()
  
  init(userId: String = "abc123") {
    self.userId = userId
  }
  
  func createMessage(issueId: Int, text: String) async throws {
    // Create URLComponents from the base URL string
    var urlComponents = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: true)
    
    // Add the query parameters
    urlComponents?.queryItems = [
      URLQueryItem(name: "user_id", value: self.userId),
      URLQueryItem(name: "issue_id", value: String(issueId)),
      URLQueryItem(name: "text", value: text)
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
    
    print(responseObject)
  }
  
  func createIssue(_ issue: Issues, completion: @escaping (Result<Int, Error>) -> Void) {
    Task {
      do {
        let issueId = try await self._createIssue(issue)
        await MainActor.run { completion(.success(issueId)) }
      } catch {
        await MainActor.run { completion(.failure(error)) }
      }
    }
  }
  
  private func _createIssue(_ issue: Issues) async throws -> Int {
    // Construct the URL
    var urlComponents = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: true)
    urlComponents?.path = "/new_issue"
    urlComponents?.queryItems = [
      URLQueryItem(name: "user_id", value: self.userId),
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
  private let baseURL = URL(string: "http://ec2-34-227-206-199.compute-1.amazonaws.com:8000")!
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
struct Message: Decodable {
  let userId: String
  let text: String
  
  enum CodingKeys: String, CodingKey {
    case userId = "user_id"
    case text
  }
}

struct MessageResponse: Decodable {
  let status: String
  let messages: [Message]
}
