//
//  UserViewModel.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 22/06/2025.
//

import KeychainAccess
import SwiftUI

extension UserView {
    
    @Observable class ViewModel {
        let keychain = Keychain(service: Constants.Bundle.id)
        
        private var appState: AppState?
        var authToken: String?
        var userId: Int?
        var user: User? = User.mock
        var userError: NetworkResponseStatus?
        
        init() {
            authToken = try? keychain.get(Constants.Bundle.tokenKey)
            userId = UserDefaults.standard.integer(forKey: Constants.Defaults.userId)
            loadUser()
        }
        
        func setup(_ appState: AppState) {
            self.appState = appState
        }
        
        func loadUser() {
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
                    
                    let result = try await NetworkManager.shared.loadUser(
                        authToken: authToken,
                        userId: userId
                    )
                    
                    switch result {
                    case .success(let tempUser):
                        print("User loaded: \(tempUser.login)")
                        await MainActor.run {
                            user = tempUser
                        }
                    case .failure(let error):
                        if error.code == 403 {
                            signOut()
                        }
                        if error.code == 404 {
                            print("User Not Found")
                            await MainActor.run {
                                self.user = nil
                                self.userError = error
                            }
                        }
                        throw error
                    }
                } catch {
                    print("❌ User failed: \(error)")
                    print("Error message: \(error.localizedDescription)")
                }
                
            }
        }
        
        func signOut() {
            UserDefaults.standard.removeObject(forKey: Constants.Defaults.accessToken)
            UserDefaults.standard.removeObject(forKey: Constants.Defaults.userId)
            Task {
                await MainActor.run {
                    appState?.isAuthenticated = false
                }
            }
        }
    }
}
