//
//  ChangeUserRoleViewModel.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 17/08/2025.
//

import Foundation
import KeychainAccess

@Observable
class ChangePrivateUserDataViewModel {
    private let keychain = Keychain(service: Constants.Bundle.id)
    private(set) var state: LoadingState<Bool> = .idle
    var showingAlert = false
    var alertMessage = ""
    
    private let userService: UserService
    private let trainingLevelService: TrainingLevelService
    private let userPlanService: UserPlansService
    
    var userId: Int?
    var authToken: String?
    
    var trainingLevels: [TrainingLevel] = []
    var userPlans: [UserPlan] = []
    
    var trainingLevel: TrainingLevel
    var userPlan: UserPlan
    
    init(
        userService: UserService = UserService(),
        trainingLevelService: TrainingLevelService = TrainingLevelService(),
        userPlanService: UserPlansService = UserPlansService()
    ) {
        authToken = try? keychain.get(Constants.Bundle.tokenKey)
        userId = UserDefaults.standard.integer(forKey: Constants.Defaults.userId)
        self.userService = userService
        self.trainingLevelService = trainingLevelService
        self.userPlanService = userPlanService
        trainingLevel = TrainingLevel(id: 1, name: "Scaled")
        userPlan = UserPlan.general
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
    
    @MainActor
    func changeUserPlan() async {
        state = .loading
        
        guard let userId else {
            Log.error("Nil userId in changeUserPlan")
            return
        }
        guard let authToken else {
            Log.error("authToken is null in changeUserPlan")
            return
        }
        
        do {
            let result = try await userService.changeUserPlan(authToken: authToken, userId: userId, userPlan: userPlan)
            
            switch result {
            case .success(let success):
                state = .loaded(success)
            case .failure(let error):
                alertMessage = "User Plan is not changed. Error: \(error.code), \(error.description)"
                showingAlert = true
                state = .error(error)
            }
        } catch {
            alertMessage = "Unexpected error during changing user plan: \(error.localizedDescription)"
            showingAlert = true
            state = .error(NetworkResponseStatus(statusCode: nil, message: error.localizedDescription))
        }
    }
    
    @MainActor
    func loadUserPlans() async {
        do {
            let result = try await userPlanService.loadUserPlans()
            
            switch result {
            case .success(let plans):
                userPlans = plans
            case .failure(let error):
                alertMessage = "User plans are not Loaded: \(error.code), \(error.description)"
                showingAlert = true
            }
        } catch {
            alertMessage = "Unexpected error during loading user plans: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}
