//
//  MainScreen.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 07.10.2026.
//

import XCTest

class MainScreen: BaseScreen {
    lazy var programTabBtn = ButtonElement("main_screen_program_tab_btn")
    lazy var createProgramTabBtn = ButtonElement("main_screen_create_program_tab_btn")
    lazy var usersControlTabBtn = ButtonElement("main_screen_users_control_tab_btn")
    lazy var userTabBtn = ButtonElement("main_screen_user_tab_btn")
    
    override var identifiebleElement: BaseUIElement { programTabBtn }
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
