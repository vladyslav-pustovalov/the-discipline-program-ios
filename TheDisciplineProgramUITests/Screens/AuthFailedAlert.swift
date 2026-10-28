//
//  AuthFailedAlert.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 28.10.2026.
//

import XCTest

final class AuthFailedAlert: BaseScreen {
    private lazy var authFailedAlertOkBtn = ButtonElement("login_screen_auth_failed_alert_ok_btn")
    
    override var identifiebleElement: BaseUIElement {
        authFailedAlertOkBtn
    }
}

//MARK: - Actions

extension AuthFailedAlert {
    
    @discardableResult func clickOk() -> LoginScreen {
        authFailedAlertOkBtn.click()
        return LoginScreen()
    }
}

//MARK: - Assertions

extension AuthFailedAlert {
    
}
