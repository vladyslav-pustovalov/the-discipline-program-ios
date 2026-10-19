//
//  SystemNotificationAlert.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 19.10.2026.
//

import XCTest

final class SystemNotificationAlert: BaseScreen {
    private lazy var dontAllowBtn = ButtonElement("Don't Allow", bundleIdentifier: springboardIdentifier)
}

//MARK: - Actions

extension SystemNotificationAlert {
    
    @discardableResult
    func dontAllowIfShown(timeout: TimeInterval = 3) -> Bool {
        if dontAllowBtn.is(.exist, within: timeout) {
            dontAllowBtn.click()
            return true
        }
        return false
    }
}

//MARK: - Assertions

extension SystemNotificationAlert {
    
}
