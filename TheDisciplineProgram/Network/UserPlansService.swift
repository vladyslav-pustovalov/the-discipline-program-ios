//
//  UserPlansService.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 30/09/2025.
//

import Foundation

final class UserPlansService: NetworkService {

    func loadUserPlans() async throws -> Result<[UserPlan], NetworkResponseStatus> {
        let headers = [
            "Content-Type": "application/json"
        ]
        
        let result = try await performRequest(
            stringURL: "\(baseURL)/userPlans",
            method: Constants.HTTPMethods.get,
            headers: headers,
            body: nil
        )
        
        switch result {
        case .success(let data):
            let userPlans = try BaseDecoder().decode([UserPlan].self, from: data)
            return .success(userPlans)
        case .failure(let status):
            return .failure(status)
        }
    }
}
