//
//  BaseScreen.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 05.10.2026.
//

import XCTest

class BaseScreen {
    private static let app = XCUIApplication()
    var window: XCUIElement
    var identifiebleElement: BaseUIElement {
        fatalError("Abstract here, should be overwritten by the clild class")
    }
    
    init(window: XCUIElement = app) {
        self.window = window
    }
    
    @discardableResult
    func isOnScreen(timeout: TimeInterval = defaultTimeout) -> Self {
        identifiebleElement.waitFor()
        return self
    }
}

//MARK: - Assertions

extension BaseScreen {
    

}
