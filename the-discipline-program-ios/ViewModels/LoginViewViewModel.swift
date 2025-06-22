//
//  LoginViewViewModel.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 22/06/2025.
//

import SwiftUI

extension LoginView {
    
    class ViewModel: ObservableObject {
        private var appState: AppState?
        
        var email = "vlad@mail.com"
        var password = "vlad123"
        var showingAlert = false
        
        var authStatus: NetworkResponseStatus?
        var authToken: String?
        var userId: Int?
                
        init() {
            self.authToken = UserDefaults.standard.string(forKey: Constants.Defaults.accessToken)
            self.userId = UserDefaults.standard.integer(forKey: Constants.Defaults.userId)
        }
        
        func setup(_ appState: AppState) {
            self.appState = appState
        }
        
        func performLogin() {
            Task {
                do {
                    let result = try await NetworkManager.shared.login(email: email, password: password)
                    switch result {
                    case .success(let jwt):
                        print("Token: \(jwt.accessToken), ID: \(jwt.userId)")
                        saveJWTDataToDefaults(jwt: jwt)
                        authToken = jwt.accessToken
                        userId = jwt.userId
                        await MainActor.run {
                            appState?.isAuthenticated = true

                        }
                    case .failure(let status):
                        print("Login fail: \(status.code); \(status.description)")
                        authStatus = status
                        showingAlert = true
                    }
                } catch {
                    print("❌ Login failed: \(error)")
                    print("Error message: \(error.localizedDescription)")
                }
            }
        }
        
        func saveJWTDataToDefaults(jwt: JwtDTO) {
            UserDefaults.standard.set(jwt.accessToken, forKey: Constants.Defaults.accessToken)
            UserDefaults.standard.set(jwt.userId, forKey: Constants.Defaults.userId)
            print("JWT data is saved to defaults")
        }
    }
}
