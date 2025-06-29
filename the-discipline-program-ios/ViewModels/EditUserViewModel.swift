//
//  EditUserViewModel.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 25/06/2025.
//

import Foundation
import KeychainAccess

@Observable
class EditUserViewModel {
    private let keychain = Keychain(service: Constants.Bundle.id)
    private(set) var state: LoadingState<User> = .idle
    var showingAlert = false
    var isUpdateSuccessful = false

    private let userService: UserService
    var user: User
    
    var authToken: String?
    
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var dateOfBirth: Date
    
    init(user: User, userService: UserService = UserService()) {
        authToken = try? keychain.get(Constants.Bundle.tokenKey)
        self.userService = userService
        self.user = user
        self.firstName = user.firstName ?? ""
        self.lastName = user.lastName ?? ""
        self.phoneNumber = user.phoneNumber ?? ""
        self.dateOfBirth = user.dateOfBirth ?? Date()
    }
    
    private func updatedUser() -> User {
        var updatedUser = User(id: user.id, login: user.login, password: user.password, userRole: user.userRole, trainingLevel: user.trainingLevel)
        updatedUser.firstName = firstName
        updatedUser.lastName = lastName
        updatedUser.phoneNumber = phoneNumber
        updatedUser.dateOfBirth = dateOfBirth
        
        return updatedUser
    }
    
    @MainActor
    func saveUpdatedUser() {
        state = .loading
        Task {
            guard let authToken else {
                print("authToken is null in update user")
                return
            }
            
            let result = try await userService.updateUser(authToken: authToken, user: updatedUser())
            
            switch result {
            case .success(let updatedUser):
                user = updatedUser
                state = .loaded(user)
                isUpdateSuccessful = true
            case .failure(let error):
                print("Error during update: \(error.code), \(error.localizedDescription)")
                state = .error(error)
                showingAlert = true
            }
        }
    }
}
