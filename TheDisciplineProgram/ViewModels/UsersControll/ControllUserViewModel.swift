//
//  ControllUserViewModel.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 02/10/2025.
//

import Foundation
import KeychainAccess

@Observable
class ControllUserViewModel {
    private let keychain = Keychain(service: Constants.Bundle.id)
    private(set) var state: LoadingState<User> = .idle
    
    private let userService: UserService
    private let trainingLevelService: TrainingLevelService
    private let userPlansService: UserPlansService
    
    var alertMessage = ""
    var showingAlert = false
    
    var authToken: String?
    var trainingLevels: [TrainingLevel] = []
    var userPlans: [UserPlan] = []
    var user: User
    
    init(
        user: User,
        userService: UserService = UserService(),
        trainingLevelService: TrainingLevelService = TrainingLevelService(),
        userPlansService: UserPlansService = UserPlansService()
    ) {
        authToken = try? keychain.get(Constants.Bundle.tokenKey)
        self.userService = userService
        self.trainingLevelService = trainingLevelService
        self.userPlansService = userPlansService
        self.user = user
    }
    
    @MainActor
    func saveUpdatedUser() async {
        state = .loading
        
        guard let authToken else {
            Log.error("Nil authToken in update user")
            return
        }
        
        do {
            let result = try await userService.updateUser(authToken: authToken, user: user)
            
            switch result {
            case .success(let updatedUser):
                user = updatedUser
                state = .loaded(updatedUser)
            case .failure(let error):
                showingAlert = true
                state = .error(error)
            }
        } catch {
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
                alertMessage = "Training levels are not loaded: \(error.code), \(error.description)"
                showingAlert = true
            }
        } catch {
            alertMessage = "Unexpected error during loading training levels: \(error.localizedDescription)"
            showingAlert = true
        }
    }
    
    @MainActor
    func loadUserPlans() async {
        do {
            let result = try await userPlansService.loadUserPlans()
            
            switch result {
            case .success(let plans):
                userPlans = plans
            case .failure(let error):
                alertMessage = "User plans are not loaded: \(error.code), \(error.description)"
                showingAlert = true
            }
        } catch {
            alertMessage = "Unexpected error during loading user plans: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}
