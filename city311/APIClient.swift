
import Foundation

@MainActor
class APIClient {
  static let shared = APIClient()
  
  init(userId: String = "abc123") {
    self.userId = userId
  }
  
  func createMessage(issueId: String, text: String, completion: @escaping (Result<[Message], Error>) -> Void) {
    Task {
      do {
        let messageResponse = try await self._createMessage(issueId: issueId, text: text)
        await MainActor.run { completion(.success(messageResponse.messages)) }
      } catch {
        await MainActor.run { completion(.failure(error)) }
      }
    }
  }
  
  private func _createMessage(issueId: String, text: String) async throws -> MessageResponse {
    var urlComponents = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: true)
    urlComponents?.path = "/new_message"
    urlComponents?.queryItems = [
      URLQueryItem(name: "user_id", value: self.userId),
      URLQueryItem(name: "issue_id", value: issueId),
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
    let responseObject = try self.decoder.decode(MessageResponse.self, from: data)
    return responseObject
  }
  
  func createIssue(_ issue: IssueType, completion: @escaping (Result<String, Error>) -> Void) {
    Task {
      do {
        let issueId = try await self._createIssue(issue)
        await MainActor.run { completion(.success(issueId)) }
      } catch {
        await MainActor.run { completion(.failure(error)) }
      }
    }
  }
  
  private func _createIssue(_ issue: IssueType) async throws -> String {
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
    
    return String(responseObject.issueId)
  }
  
  private lazy var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()
  
  private let userId: String
  private let baseURL = URL(string: "http://ec2-34-227-206-199.compute-1.amazonaws.com:8000")!
}

// MARK: - CreateIssueResponse

struct CreateIssueResponse: Decodable {
  let userId: String
  let issueId: String
  let issueType: String
}

// MARK: - MessageResponse

struct MessageResponse: Decodable {
  let status: String
  let messages: [Message]
}

struct Message: Decodable, Identifiable {
  let userId: String
  let text: String
  
  var id: String {
    userId + text
  }
}
