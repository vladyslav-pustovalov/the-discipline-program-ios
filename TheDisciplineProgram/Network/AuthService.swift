//
//  AuthService.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 25/06/2025.
//

import Foundation

final class AuthService: NetworkService {
    
    func login(email: String, password: String) async throws -> Result<JwtDTO, NetworkResponseStatus> {
        let headers = [
            "Content-Type": "application/json",
        ]
        let body = try BaseEncoder().encode(SignInDTO(username: email, password: password))

        let result = try await performRequest(
            stringURL: "\(baseURL)/auth/signin",
            method: Constants.HTTPMethods.post,
            headers: headers,
            body: body
        )
        
        switch result {
        case .success(let data):
            do {
                let jwt = try BaseDecoder().decode(JwtDTO.self, from: data)
                return .success(jwt)
            } catch {
                return .failure(NetworkResponseStatus(statusCode: 422, message: "Error during auth response decoding"))
            }
        case .failure(let status):
            return .failure(status)
        }
    }
}
