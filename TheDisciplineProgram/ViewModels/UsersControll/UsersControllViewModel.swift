//
//  UsersControllViewModel.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 02/10/2025.
//

import Foundation
import KeychainAccess

@Observable
class UsersControllViewModel {
    private let keychain = Keychain(service: Constants.Bundle.id)
    private(set) var state: LoadingState<[User]> = .idle
    private let userService: UserService
    
    var authToken: String?

    var searchText = ""
    var alertMessage = ""
    var showingAlert = false
    
    var users: [User]?
    
    init(
        userService: UserService = UserService()
    ) {
        authToken = try? keychain.get(Constants.Bundle.tokenKey)
        self.userService = userService
    }
    
    func searchUsers(from users: [User]) -> [User] {
        guard searchText.isEmpty else { return users }
        return users.filter { $0.visibleName.contains(searchText) }
    }
    
    @MainActor
    func loadUsers() async {
        state = .loading
        
        guard let authToken else {
            Log.error(("Nil authToken in update program"))
            return
        }
        
        do {
            let result = try await userService.loadUsers(authToken: authToken)
            
            switch result {
            case .success(let users):
                self.users = users
                state = .loaded(users)
            case .failure(let error):
                alertMessage = "Users are not loaded: \(error.code), \(error.description)"
                showingAlert = true
                state = .error(error)
            }
        } catch {
            alertMessage = "Unexpected error during loading users: \(error.localizedDescription)"
            showingAlert = true
            state = .error(NetworkResponseStatus(statusCode: nil))
        }
    }
}
