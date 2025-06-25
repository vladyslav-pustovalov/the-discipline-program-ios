//
//  AuthService.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 25/06/2025.
//

import Foundation

class AuthService: NetworkService {
    
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
}
