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
            .signInExpecting(MainScreen.self)
            .isOnScreen()
    }
    
    func testUserCanNotLoginWithNotValidCredentials() {
        LoginScreen()
            .isOnScreen()
            .enterEmail(validCredentials.email)
            .enterPasword(validCredentials.password + "a")
            .signInExpecting(AuthFailedAlert.self)
            .isOnScreen()
            .clickOk()
            .isOnScreen()
    }
    
    func testUserCanSignOut() {
        LoginScreen()
            .isOnScreen()
            .enterEmail(validCredentials.email)
            .enterPasword(validCredentials.password)
            .signInExpecting(MainScreen.self)
            .isOnScreen()
            .selectUserTab()
            .signOut()
            .isOnScreen()
    }
}
