//
//  UserViewModel.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 22/06/2025.
//

import KeychainAccess
import SwiftUI

@Observable class UserViewModel {
    private let keychain = Keychain(service: Constants.Bundle.id)
    private(set) var state: LoadingState<User> = .idle
    
    var authToken: String?
    var userId: Int?
    var user: User? = User.mock
    
    private let userService: UserService
    
    init(userService: UserService = UserService()) {
        self.userService = userService
        authToken = try? keychain.get(Constants.Bundle.tokenKey)
        userId = UserDefaults.standard.integer(forKey: Constants.Defaults.userId)
    }
    
    func loadUser() {
        state = .loading
        Task {
            do {
                guard let userId else {
                    print("Nil userId in loadUser")
                    return
                }
                guard let authToken else {
                    print("Nil authToken in loadUser")
                    return
                }
                
                let result = try await userService.loadUser(
                    authToken: authToken,
                    userId: userId
                )
                
                switch result {
                case .success(let tempUser):
                    print("User loaded: \(tempUser.login)")
                    await MainActor.run {
                        user = tempUser
                        state = .loaded(tempUser)
                    }
                case .failure(let error):
                    if error.code == 403 {
                        
                    }
                    
                    if error.code == 404 {
                        print("User Not Found")
                        await MainActor.run {
                            self.user = nil
                        }
                    }
                    state = .error(error)
                }
            } catch {
                print("❌ User failed: \(error)")
                print("Error message: \(error.localizedDescription)")
            }
            
        }
    }
}
