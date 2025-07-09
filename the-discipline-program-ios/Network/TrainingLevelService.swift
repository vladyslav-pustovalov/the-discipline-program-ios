//
//  TrainingLevelService.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 09/07/2025.
//

import Foundation

final class TrainingLevelService: NetworkService {
    
    func loadTrainingLevels(authToken: String) async throws -> Result<[TrainingLevel], NetworkResponseStatus> {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": authToken
        ]
        
        let result = try await performRequest(
            stringURL: "\(baseURL)/trainingLevel/all",
            method: Constants.HTTPMethods.get,
            headers: headers,
            body: nil
        )
        
        switch result {
        case .success(let data):
            let trainingLevels = try BaseDecoder().decode([TrainingLevel].self, from: data)
            print("Level: \(trainingLevels.first?.name)")
            return .success(trainingLevels)
        case .failure(let status):
            return .failure(status)
        }
    }
}
