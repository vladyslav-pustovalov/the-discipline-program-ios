//
//  MainScreen.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 07.10.2026.
//

import XCTest

class MainScreen: BaseScreen {
    private lazy var notificationDisabledAlert = NotificationsDisabledAlert()
    private lazy var savePasswordAlert = SavePasswordAlert()
    private lazy var systemNotificationAlert = SystemNotificationAlert()
    
    private lazy var programTabBtn = ButtonElement("list.dash")
    private lazy var createProgramTabBtn = ButtonElement("document.badge.plus")
    private lazy var usersControlTabBtn = ButtonElement("person.2.badge.gearshape.fill")
    private lazy var userTabBtn = ButtonElement("person.circle")
    
    override var identifiebleElement: BaseUIElement { programTabBtn }
    
    @discardableResult
    override func isOnScreen(timeout: TimeInterval = defaultTimeout) -> Self {
        systemNotificationAlert.dontAllowIfShown()
        savePasswordAlert.clickNotNow()
        notificationDisabledAlert.closeIfShown()
        identifiebleElement.waitFor()
        return self
    }
}

// MARK: - Actions

extension MainScreen {
    @discardableResult
    func selectProgramTab() -> Self {
        programTabBtn.click()
        return self
    }
    
    @discardableResult
    func selectCreateProgramTab() -> Self {
        createProgramTabBtn.click()
        return self
    }
    
    @discardableResult
    func selectUsersControlTab() -> Self {
        usersControlTabBtn.click()
        return self
    }
    
    @discardableResult
    func selectUserTab() -> Self {
        userTabBtn.click()
        return self
    }
}

// MARK: - Assertions

extension MainScreen {
    
}
