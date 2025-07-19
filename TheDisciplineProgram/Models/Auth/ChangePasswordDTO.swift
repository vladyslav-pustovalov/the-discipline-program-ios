//
//  ChangePasswordDTO.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 30/06/2025.
//

struct ChangePasswordDTO: Codable {
    private(set) var userId: Int
    private(set) var oldPassword: String
    private(set) var newPassword: String
}
