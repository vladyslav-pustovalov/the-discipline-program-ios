//
//  SignUpDTO.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 16/06/2025.
//

struct SignUpDTO: Codable {
    let username: String
    let password: String
    let trainingLevel: TrainingLevel
    let userPlan: UserPlan
}

extension SignUpDTO {
    static var mock = SignUpDTO(username: "vlad@mail.com", password: "vlad123", trainingLevel: TrainingLevel.pro, userPlan: UserPlan.general)
}
