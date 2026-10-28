//
//  UserScreen.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 28.10.2026.
//

import XCTest

final class UserScreen: MainScreen {
    private lazy var signOutBtn = ButtonElement("user_screen_sign_out_btn")
    
    override var identifiebleElement: BaseUIElement {
        signOutBtn
    }
}

// MARK: - Actions

extension UserScreen {

    @discardableResult
    func signOut() -> LoginScreen {
        signOutBtn.click()
        return LoginScreen()
    }
}

// MARK: - Assertions

extension UserScreen {
    
}
