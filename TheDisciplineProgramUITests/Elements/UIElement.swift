//
//  BaseElement.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 05.10.2026.
//

import XCTest

class BaseUIElement {
    static let app = XCUIApplication()
    fileprivate var element: XCUIElement
    
    init(elementType: ElementType, identifier: String) {
        element = elementType.toQuery().matching(identifier: identifier).firstMatch
    }
    
    @discardableResult
    func waitFor(_ timeout: TimeInterval = defaultTimeout) -> Self {
        guard element.waitForExistence(timeout: timeout) else {
            XCTFail("❌ Failed to find '\(element.description)'"); return self
        }
        return self
    }
    
    enum ElementType {
        case button, icon, staticText, secureTextField, tabView, textField
        
        fileprivate func toQuery() -> XCUIElementQuery {
            switch self {
            case .button: return app.buttons
            case .icon: return app.icons
            case .staticText: return app.staticTexts
            case .secureTextField: return app.secureTextFields
            case .tabView: return app.tabs
            case .textField: return app.textFields
            }
        }
    }
}

final class ButtonElement: BaseUIElement {
    
    init(_ identifier: String) {
        super.init(elementType: .button, identifier: identifier)
    }
    
    func click() {
        self.waitFor(5)
        element.tap()
    }
}

final class IconElement: BaseUIElement {
    
    init(_ identifier: String) {
        super.init(elementType: .icon, identifier: identifier)
    }
    
    func press(for duration: TimeInterval) {
        self.waitFor(5)
        element.press(forDuration: duration)
    }
}

final class StaticTextElement: BaseUIElement {
    var text: String {
        element.label
    }
    
    init(_ identifier: String) {
        super.init(elementType: .staticText, identifier: identifier)
    }
}

final class SecureTextFieldElement: TextFieldElement {
    
    override init(_ identifier: String) {
        super.init(elementType: .secureTextField, identifier: identifier)
    }
}

final class TabViewElement: BaseUIElement {
    init(_ identifier: String) {
        super.init(elementType: .tabView, identifier: identifier)
    }
}

class TextFieldElement: BaseUIElement {
    
    init(_ identifier: String) {
        super.init(elementType: .textField, identifier: identifier)
    }
    
    fileprivate override init(elementType: BaseUIElement.ElementType, identifier: String) {
        super.init(elementType: elementType, identifier: identifier)
    }
    
    func clearText() {
        guard let stringValue = self.element.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        element.tap()
        _ = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
    }
    
    func typeText(_ text: String) {
        element.tap()
        element.typeText(text)
    }
}
