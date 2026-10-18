//
//  LoginScreen.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 05.10.2026.
//

import XCTest

final class LoginScreen: BaseScreen {
    private lazy var welcomeMessage = StaticTextElement("login_screen_welcome_msg")
    
    private lazy var emailTf = TextFieldElement("login_screen_email_tf")
    private lazy var passwordTf = SecureTextFieldElement("login_screen_password_stf")
    private lazy var singInBtn = ButtonElement("login_screen_sign_in_btn")
    
    private lazy var instagramBtn = ButtonElement("login_screen_instagram_btn")
    private lazy var telegramBtn = ButtonElement("login_screen_telegram_btn")
    private lazy var youtubeBtn = ButtonElement("login_screen_youtube_btn")
    
    private lazy var authFailedAlertOkBtn = ButtonElement("login_screen_auth_failed_alert_ok_btn")
    private lazy var authFailedAlertMsg = StaticTextElement("login_screen_auth_failed_alert_msg")
    
    override var identifiebleElement: BaseUIElement { welcomeMessage }
}

// MARK: - Actions

extension LoginScreen {
    
    @discardableResult func enterEmail(_ email: String) -> Self {
        emailTf.typeText(email)
        return self
    }
    
    @discardableResult func enterPasword(_ password: String) -> Self {
        passwordTf.typeText(password)
        return self
    }
    
    @discardableResult func signInSuccessfully() -> MainScreen {
        clickSignIn()
        XCUIApplication().dismissSavePasswordAlertIfPresent()
        return MainScreen()
    }
    
    private func clickSignIn() {
        singInBtn.click()
    }
}

// MARK: - Assertions

extension LoginScreen {
    
}
