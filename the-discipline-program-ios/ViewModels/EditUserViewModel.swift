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
    
    var login: String
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    
    init(user: User, userService: UserService = UserService()) {
        authToken = try? keychain.get(Constants.Bundle.tokenKey)
        self.userService = userService
        self.user = user
        self.login = user.login
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.phoneNumber = user.phoneNumber
    }
    
    private func updatedUser() -> User {
        return User(
            id: user.id,
            login: login,
            password: user.password,
            userRole: user.userRole,
            trainingLevel: user.trainingLevel,
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: user.dateOfBirth,
            phoneNumber: phoneNumber
        )
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
                print("User is updated: \(updatedUser.login)")
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
