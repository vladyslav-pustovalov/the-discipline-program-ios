//
//  NetworkManager.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 18/06/2025.
//

import Foundation

class NetworkService {
    private struct NetworkError: Codable {
        let error: String?
    }
    
    static let shared = NetworkService()
    
    private let session = URLSession.shared
    let baseURL = "\(Constants.API.baseURL)\(Constants.API.basePath)\(Constants.API.versionAPI)"
    
    func performRequest(stringURL: String, method: String, headers: [String: String], body: Data?) async throws -> Result<Data, NetworkResponseStatus> {
        guard let url = URL(string: stringURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        request.httpBody = body
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(NetworkResponseStatus(statusCode: nil, message: "Invalid response"))
        }
        
        let networkResponseStatus = NetworkResponseStatus(statusCode: httpResponse.statusCode)
        
        switch networkResponseStatus {
        case .success(let status, _):
            if status == .ok {
                return .success(data)
            } else {
                return .failure(networkResponseStatus)
            }
        default:
            if let model = try? BaseDecoder().decode(NetworkError.self, from: data) {
                return .failure(NetworkResponseStatus(statusCode: httpResponse.statusCode, message: model.error))
            }
            return .failure(networkResponseStatus)
        }
    }
}
