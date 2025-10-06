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
        var updatedUser = User(id: user.id, isEnabled: user.isEnabled, username: user.username, userRole: user.userRole, trainingLevel: user.trainingLevel)
        updatedUser.firstName = firstName
        updatedUser.lastName = lastName
        updatedUser.phoneNumber = phoneNumber
        updatedUser.dateOfBirth = dateOfBirth
        
        return updatedUser
    }
    
    @MainActor
    func saveUpdatedUser() async {
        state = .loading
        
        guard let authToken else {
            Log.error("Nil authToken in update user")
            return
        }
        
        do {
            let result = try await userService.updateUser(authToken: authToken, user: updatedUser())
            
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
}
