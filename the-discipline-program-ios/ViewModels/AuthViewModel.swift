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
    var userRole: UserRole?
    var authStatus: NetworkResponseStatus?
    
    var email = "vladyslav.pustovalov@gmail.com"
    var password = "12345"
    var isLoginButtonDisabled: Bool {
        email.isEmpty || password.isEmpty
    }
    
    private let authService: AuthService
    
    init(authService: AuthService = AuthService()) {
        if let token = try? keychain.get(Constants.Bundle.tokenKey) {
            authToken = token
            isAuthenticated = true
        }
        
        let userRoleData = UserDefaults.standard.data(forKey: Constants.Defaults.userRole)
        
        if let userRoleData {
            print("userrole data is not null")
            if let role = try? BaseDecoder().decode(UserRole.self, from: userRoleData) {
                print("userrole = \(role.name)")
                userRole = role
            }
        }
        
        self.authService = authService
    }
    
    func performLogin() {
        isLoading = true
        
        Task {
            let result = try await authService.login(email: email, password: password)
            switch result {
            case .success(let jwt):
                print("Token: \(jwt.accessToken), ID: \(jwt.userId), Role: \(jwt.userRole.name)")
                saveJWTData(jwt: jwt)
                authToken = jwt.accessToken
                userId = jwt.userId
                userRole = jwt.userRole
                isAuthenticated = true
                isLoading = false
            case .failure(let status):
                print("Login fail: \(status.code); \(status.description)")
                authStatus = status
                showingAlert = true
                isLoading = false
            }
        }
    }
    
    func signOut() {
        try? keychain.remove(Constants.Bundle.tokenKey)
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.userId)
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.userRole)
        isAuthenticated = false
    }
    
    func saveJWTData(jwt: JwtDTO) {
        try? keychain.set(jwt.accessToken, key: Constants.Bundle.tokenKey)
        UserDefaults.standard.set(jwt.userId, forKey: Constants.Defaults.userId)
        if let data = try? BaseEncoder().encode(jwt.userRole) {
            UserDefaults.standard.set(data, forKey: Constants.Defaults.userRole)
        }
        print("JWT data is saved")
    }
}
