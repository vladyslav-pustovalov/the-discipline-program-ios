//
//  ChangePasswordViewModel.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 30/06/2025.
//

import Foundation
import KeychainAccess

@Observable
class ChangePasswordViewModel {
    private let keychain = Keychain(service: Constants.Bundle.id)
    private(set) var state: LoadingState<Bool> = .idle
    var showingAlert = false
    
    private let userService: UserService
    
    var userId: Int?
    var authToken: String?
    
    var oldPassword = ""
    var newPassword = ""
    var confirmNewPassword = ""
    var isNewPasswordConfirmed: Bool {
        newPassword == confirmNewPassword
    }
    var isOldAndNewPasswordsTheSame: Bool {
        oldPassword == newPassword
    }
    
    init(userService: UserService = UserService()) {
        authToken = try? keychain.get(Constants.Bundle.tokenKey)
        userId = UserDefaults.standard.integer(forKey: Constants.Defaults.userId)
        self.userService = userService
    }
    
    @MainActor
    func saveNewPassword() async {
        state = .loading
        
        guard let userId else {
            Log.error("Nil userId in changePassword")
            return
        }
        guard let authToken else {
            Log.error("authToken is null in changePassword")
            return
        }
        
        do {
            let result = try await userService.changeUserPassword(authToken: authToken, userId: userId, newPassword: newPassword, oldPassword: oldPassword)
            
            switch result {
            case .success(let success):
                state = .loaded(success)
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
