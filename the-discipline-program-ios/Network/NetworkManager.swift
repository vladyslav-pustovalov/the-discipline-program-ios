//
//  NetworkService.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 18/06/2025.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    
    private let session = URLSession.shared
    private let baseURL = "\(Constants.API.baseURL)\(Constants.API.basePath)\(Constants.API.versionAPI)"
    
    private func performRequest(url: String) async -> Result<Data, Respon
    
    func login(email: String, password: String) async throws -> JwtDTO {
        guard let url = URL(string: "\(baseURL)/auth/signin") else {
            throw URLError(.badURL)
        }

        let credentials = SignInDTO(login: email, password: password)
        var request = URLRequest(url: url)
        request.httpMethod = Constants.HTTPMethods.post
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(credentials)

        let (data, _) = try await session.data(for: request)

        let jwt = try JSONDecoder().decode(JwtDTO.self, from: data)
        return jwt
    }
    
    func loadProgram(authToken: String, userId: Int, date: Date) async throws -> Program {
        var components = URLComponents(string: "\(baseURL)/program")
        components?.queryItems = [
            URLQueryItem(name: "userId", value: String(userId)),
            URLQueryItem(name: "scheduledDate", value: Constants.Formatter.dateFormatter.string(from: date))
        ]
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.HTTPMethods.get
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        request.setValue(
            authToken,
            forHTTPHeaderField: "Authorization"
        )
        
        let (data, _) = try await session.data(for: request)
        
        let program = try JSONDecoder().decode(Program.self, from: data)
        return program
    }
    
    func loadUser(authToken: String, userId: Int) async throws -> User {
        guard let url = URL(string: "\(baseURL)/user/\(userId)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.HTTPMethods.get
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        request.setValue(
            authToken,
            forHTTPHeaderField: "Authorization"
        )
        
        let (data, _) = try await session.data(for: request)
        
        let user = try JSONDecoder().decode(User.self, from: data)
        return user
    }
}
