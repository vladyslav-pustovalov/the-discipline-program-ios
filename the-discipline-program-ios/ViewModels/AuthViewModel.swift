//
//  AuthViewModel.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 22/06/2025.
//

import KeychainAccess
import SwiftUI

@Observable
class AuthViewModel {
    let keychain = Keychain(service: Constants.Bundle.id)
    
    var isAuthenticated = false
    var showingAlert = false
    var isLoading = false
    
    var userId: Int?
    var authToken: String?
    var authStatus: NetworkResponseStatus?
    
    var email = "vlad@mail.com"
    var password = "vlad123"
    var isLoginButtonDisabled: Bool {
        email.isEmpty || password.isEmpty
    }
    
    private let authService: AuthService
    
    init(authService: AuthService = AuthService()) {
        if let token = try? keychain.get(Constants.Bundle.tokenKey) {
            authToken = token
            //            isAuthenticated = true
        }
        self.authService = authService
    }
    
    func performLogin() {
        isLoading = true
        
        Task {
            let result = try await authService.login(email: email, password: password)
            switch result {
            case .success(let jwt):
                print("Token: \(jwt.accessToken), ID: \(jwt.userId)")
                saveJWTData(jwt: jwt)
                authToken = jwt.accessToken
                userId = jwt.userId
                isAuthenticated = true
            case .failure(let status):
                print("Login fail: \(status.code); \(status.description)")
                authStatus = status
                showingAlert = true
            }
            isLoading = false
        }
    }
    
    func signOut() {
        try? keychain.remove(Constants.Bundle.tokenKey)
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.userId)
        isAuthenticated = false
    }
    
    func saveJWTData(jwt: JwtDTO) {
        try? keychain.set(jwt.accessToken, key: Constants.Bundle.tokenKey)
        UserDefaults.standard.set(jwt.userId, forKey: Constants.Defaults.userId)
        print("JWT data is saved")
    }
}
