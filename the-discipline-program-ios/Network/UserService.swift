//
//  UserService.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 25/06/2025.
//

import Foundation

final class UserService: NetworkService {
    
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
