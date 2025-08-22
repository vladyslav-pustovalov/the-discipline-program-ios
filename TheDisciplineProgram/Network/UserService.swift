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
            let user = try BaseDecoder().decode(User.self, from: data)
            return .success(user)
        case .failure(let status):
            return .failure(status)
        }
    }
    
    func updateUser(authToken: String, user: User) async throws -> Result<User, NetworkResponseStatus> {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": authToken
        ]
        
        let body = try BaseEncoder().encode(user)
        
        let result = try await performRequest(
            stringURL: "\(baseURL)/user",
            method: Constants.HTTPMethods.put,
            headers: headers,
            body: body
        )
        
        switch result {
        case .success(let data):
            do {
                let user = try BaseDecoder().decode(User.self, from: data)
                return .success(user)
            } catch is DecodingError {
                return .failure(NetworkResponseStatus(statusCode: 422, message: "Error during user data decoding"))
            }
        case .failure(let status):
            return .failure(status)
        }
    }
    
    func changeUserPassword(authToken: String, userId: Int, newPassword: String, oldPassword: String) async throws -> Result<Bool, NetworkResponseStatus> {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": authToken
        ]
        
        let body = try BaseEncoder().encode(ChangePasswordDTO(userId: userId, oldPassword: oldPassword, newPassword: newPassword))
        
        let result = try await performRequest(
            stringURL: "\(baseURL)/user/changePassword",
            method: Constants.HTTPMethods.patch,
            headers: headers,
            body: body
        )
        
        switch result {
        case .success(_):
            return .success(true)
        case .failure(let status):
            return .failure(status)
        }
    }
    
    func changeTrainingLevel(authToken: String, userId: Int, trainingLevel: TrainingLevel) async throws -> Result<Bool, NetworkResponseStatus> {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": authToken
        ]
        
        let body = try BaseEncoder().encode(trainingLevel)
        
        let result = try await performRequest(
            stringURL: "\(baseURL)/user/\(userId)/changeTrainingLevel",
            method: Constants.HTTPMethods.patch,
            headers: headers,
            body: body
        )
        
        switch result {
        case .success(_):
            return .success(true)
        case .failure(let status):
            return .failure(status)
        }
    }
}
