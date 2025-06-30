//
//  SignUpDTO.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 16/06/2025.
//

struct SignUpDTO: Codable {
    let username: String
    let password: String
    let userRole: UserRole
}

extension SignUpDTO {
    static var mock = SignUpDTO(username: "vlad@mail.com", password: "vlad123", userRole: UserRole.roleAdmin)
}
