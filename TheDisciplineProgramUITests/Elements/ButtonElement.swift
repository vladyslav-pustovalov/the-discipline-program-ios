//
//  ButtonElement.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 05.10.2026.
//

import XCTest

final class ButtonElement: BaseUIElement {
    
    init(_ identifier: String, bundleIdentifier: String? = nil) {
        super.init(elementType: .button, identifier: identifier, bundleIdentifier: bundleIdentifier)
    }
    
    func click() {
        self.waitFor(5)
        element.tap()
    }
    
    func clickIfShown(within timeout: TimeInterval = 3) {
        if self.is(.exist, within: timeout) {
            self.click()
        }
    }
}

final class IconElement: BaseUIElement {
    
    init(_ identifier: String, bundleIdentifier: String? = nil) {
        super.init(elementType: .icon, identifier: identifier, bundleIdentifier: bundleIdentifier)
    }
    
    func press(for duration: TimeInterval) {
        self.waitFor(5)
        element.press(forDuration: duration)
    }
}

final class SecureTextFieldElement: TextFieldElement {
    
    override init(_ identifier: String, bundleIdentifier: String? = nil) {
        super.init(elementType: .secureTextField, identifier: identifier, bundleIdentifier: bundleIdentifier)
    }
}

final class StaticTextElement: BaseUIElement {
    var text: String {
        element.label
    }
    
    init(_ identifier: String, bundleIdentifier: String? = nil) {
        super.init(elementType: .staticText, identifier: identifier, bundleIdentifier: bundleIdentifier)
    }
}

final class TabViewElement: BaseUIElement {
    init(_ identifier: String, bundleIdentifier: String? = nil) {
        super.init(elementType: .tab, identifier: identifier, bundleIdentifier: bundleIdentifier)
    }
}

class TextFieldElement: BaseUIElement {
    
    init(_ identifier: String, bundleIdentifier: String? = nil) {
        super.init(elementType: .textField, identifier: identifier, bundleIdentifier: bundleIdentifier)
    }
    
    override init(elementType: XCUIElement.ElementType, identifier: String, bundleIdentifier: String? = nil) {
        super.init(elementType: elementType, identifier: identifier, bundleIdentifier: bundleIdentifier)
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
