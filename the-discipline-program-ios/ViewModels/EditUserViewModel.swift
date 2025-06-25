//
//  EditUserViewModel.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 25/06/2025.
//

import Foundation

@Observable
class EditUserViewModel {
    private let user: User
    var login: String
    
    var isSaving = false
    var errorMessage: String?
    
    init(user: User) {
        self.user = user
        self.login = user.login
    }
    
    func updatedUser() -> User {
        return User(id: user.id, login: user.login, password: user.password, userRole: user.userRole)
    }
    
    @MainActor
    func save() async throws -> User {
        isSaving = true
        defer { isSaving = false }
        
        return self.updatedUser()
    }
}
