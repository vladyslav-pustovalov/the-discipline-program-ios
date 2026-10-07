//
//  LoginTests.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 07.10.2026.
//

import XCTest

final class LoginTests: BaseTest {
    
    func testUserCanLoginWithValidCredentials() {
        LoginScreen()
            .isOnScreen()
            .enterEmail(validCredentials.email)
            .enterPasword(validCredentials.password)
            .signInSuccessfully()
            .isOnScreen()
    }
}
