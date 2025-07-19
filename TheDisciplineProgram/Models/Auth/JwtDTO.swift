//
//  JwtDTO.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 15/06/2025.
//

struct JwtDTO: Codable {
    let userId: Int
    let accessToken: String
    let userRole: UserRole
}
