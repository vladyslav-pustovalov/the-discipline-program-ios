//
//  UserViewModel.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 22/06/2025.
//

import KeychainAccess
import SwiftUI

@Observable
class UserViewModel {
    private let keychain = Keychain(service: Constants.Bundle.id)
    private(set) var state: LoadingState<User> = .idle
    
    var authToken: String?
    var userId: Int?
    var user: User?
    
    private let userService: UserService
    
    init(userService: UserService = UserService()) {
        self.userService = userService
        authToken = try? keychain.get(Constants.Bundle.tokenKey)
        userId = UserDefaults.standard.integer(forKey: Constants.Defaults.userId)
    }
    
    @MainActor
    func loadUser() {
        state = .loading
        Task {
            guard let userId else {
                Log.error("Nil userId in loadUser")
                return
            }
            guard let authToken else {
                Log.error("Nil authToken in loadUser")
                return
            }
            
            let result = try await userService.loadUser(
                authToken: authToken,
                userId: userId
            )
            
            switch result {
            case .success(let tempUser):
                user = tempUser
                state = .loaded(tempUser)
            case .failure(let error):
                if error.code == 403 {
                    Log.info("Forbidden to load user")
                }
                if error.code == 404 {
                    Log.info("User not found")
                    self.user = nil
                }
                state = .error(error)
            }
        }
    }
    
    func updateUser(_ user: User) {
        self.state = .loaded(user)
    }
}
