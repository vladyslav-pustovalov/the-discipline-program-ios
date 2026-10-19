//
//  NotificationsDisabledAlert.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 18.10.2026.
//

import XCTest

final class NotificationsDisabledAlert: BaseScreen {
    private lazy var goToSettingsBtn = ButtonElement("notifications_disabled_alert_go_to_settings_btn")
    private lazy var calcelBtn = ButtonElement("notifications_disabled_alert_cancel_btn")
}

// MARK: - Actions

extension NotificationsDisabledAlert {
    
    func close() {
        calcelBtn.click()
    }
    
    func goToSettings() {
        goToSettingsBtn.click()
    }
}

// MARK: - Assertions
 
extension NotificationsDisabledAlert {
    
}
