//
//  ChangeUserRoleViewModel.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 17/08/2025.
//

import Foundation
import KeychainAccess

@Observable
class ChangeTrainingLevelViewModel {
    private let keychain = Keychain(service: Constants.Bundle.id)
    private(set) var state: LoadingState<Bool> = .idle
    var showingAlert = false
    var alertMessage = ""
    
    private let userService: UserService
    private let trainingLevelService: TrainingLevelService
    
    var userId: Int?
    var authToken: String?
    
    var trainingLevels: [TrainingLevel] = []
    var trainingLevel: TrainingLevel
    
    init(userService: UserService = UserService(), trainingLevelService: TrainingLevelService = TrainingLevelService()) {
        authToken = try? keychain.get(Constants.Bundle.tokenKey)
        userId = UserDefaults.standard.integer(forKey: Constants.Defaults.userId)
        self.userService = userService
        self.trainingLevelService = trainingLevelService
        trainingLevel = TrainingLevel(id: 1, name: "Scaled")
    }
    
    @MainActor
    func changeTrainingLevel() async {
        state = .loading
        
        guard let userId else {
            Log.error("Nil userId in changeTrainingLevel")
            return
        }
        guard let authToken else {
            Log.error("authToken is null in changeTrainingLevel")
            return
        }
        
        do {
            let result = try await userService.changeTrainingLevel(authToken: authToken, userId: userId, trainingLevel: trainingLevel)
            
            switch result {
            case .success(let success):
                state = .loaded(success)
            case .failure(let error):
                alertMessage = "Training Level is not changed. Error: \(error.code), \(error.description)"
                showingAlert = true
                state = .error(error)
            }
        } catch {
            alertMessage = "Unexpected error during changing training level: \(error.localizedDescription)"
            showingAlert = true
            state = .error(NetworkResponseStatus(statusCode: nil, message: error.localizedDescription))
        }
    }
    
    @MainActor
    func loadTrainingLevels() async {
        
        do {
            let result = try await trainingLevelService.loadTrainingLevels()
            
            switch result {
            case .success(let levels):
                trainingLevels = levels
            case .failure(let error):
                alertMessage = "Training levels are not Loaded: \(error.code), \(error.description)"
                showingAlert = true
            }
        } catch {
            alertMessage = "Unexpected error during loading training levels: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}
