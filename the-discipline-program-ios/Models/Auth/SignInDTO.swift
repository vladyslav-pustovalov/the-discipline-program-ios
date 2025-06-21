//
//  SignInDTO.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 15/06/2025.
//

struct SignInDTO: Codable {
    let login: String
    let password: String
}

extension SignInDTO {
    static var mock = SignInDTO(login: "vlad@mail.com", password: "vlad123")
}
