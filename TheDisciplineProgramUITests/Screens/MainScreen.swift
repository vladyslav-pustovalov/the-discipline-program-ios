//
//  MainScreen.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 07.10.2026.
//

import XCTest

class MainScreen: BaseScreen {
    lazy var programTabBtn = ButtonElement("list.dash")
    lazy var createProgramTabBtn = ButtonElement("document.badge.plus")
    lazy var usersControlTabBtn = ButtonElement("person.2.badge.gearshape.fill")
    lazy var userTabBtn = ButtonElement("person.circle")
    
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
