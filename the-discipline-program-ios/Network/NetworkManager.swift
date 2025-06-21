//
//  NetworkManager.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 18/06/2025.
//

import Foundation

final class NetworkManager {
    private struct NetworkError: Codable {
        let error: String?
    }
    
    static let shared = NetworkManager()
    
    private let session = URLSession.shared
    private let baseURL = "\(Constants.API.baseURL)\(Constants.API.basePath)\(Constants.API.versionAPI)"
    
    private func performRequest(stringURL: String, method: String, headers: [String: String], body: Data?) async throws -> Result<Data, NetworkResponseStatus> {
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
            let decoder = JSONDecoder()
            if let model = try? decoder.decode(NetworkError.self, from: data) {
                return .failure(NetworkResponseStatus(statusCode: httpResponse.statusCode, message: model.error))
            }
            return .failure(networkResponseStatus)
        }
    }
    
    func login(email: String, password: String) async throws -> Result<JwtDTO, NetworkResponseStatus> {
        let headers = [
            "Content-Type": "application/json",
        ]
        let body = try JSONEncoder().encode(SignInDTO(login: email, password: password))

        let result = try await performRequest(
            stringURL: "\(baseURL)/auth/signin",
            method: Constants.HTTPMethods.post,
            headers: headers,
            body: body
        )
        
        switch result {
        case .success(let data):
            let jwt = try JSONDecoder().decode(JwtDTO.self, from: data)
            return .success(jwt)
        case .failure(let status):
            return .failure(status)
        }
    }
    
    func loadProgram(authToken: String, userId: Int, date: Date) async throws -> Result<Program, NetworkResponseStatus> {
        let stringDate = Constants.Formatter.dateFormatter.string(from: date)
        print("String date: \(stringDate)")
        let stringURL = "\(baseURL)/program?userId=\(userId)&scheduledDate=\(stringDate)"
        let headers = [
            "Content-Type": "application/json",
            "Authorization": authToken
        ]
        
        let result = try await performRequest(
            stringURL: stringURL,
            method: Constants.HTTPMethods.get,
            headers: headers,
            body: nil
        )
        
        switch result {
        case .success(let data):
            let program = try JSONDecoder().decode(Program.self, from: data)
            return .success(program)
        case .failure(let status):
            return .failure(status)
        }
    }
    
    func loadUser(authToken: String, userId: Int) async throws -> Result<User, NetworkResponseStatus> {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": authToken
        ]
        
        let result = try await performRequest(
            stringURL: "\(baseURL)/user/\(userId)",
            method: Constants.HTTPMethods.get,
            headers: headers,
            body: nil
        )
        
        switch result {
        case .success(let data):
            let user = try JSONDecoder().decode(User.self, from: data)
            return .success(user)
        case .failure(let status):
            return .failure(status)
        }
    }
}
