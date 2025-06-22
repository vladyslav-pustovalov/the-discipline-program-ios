//
//  UserRole.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

struct UserRole: Codable {
    private(set) var id: Int
    private(set) var name: String
}

enum UserRoleType {
    case user
    case admin
}

extension UserRole {
    static var roleUser = UserRole(id: 1, name: "USER")
    static var roleAdmin = UserRole(id: 2, name: "ADMIN")
}
