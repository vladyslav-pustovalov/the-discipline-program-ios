//
//  BaseElement.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 05.10.2026.
//

import XCTest

class BaseUIElement {
    private let app: XCUIApplication
    let element: XCUIElement
    
    init(elementType: ElementType, identifier: String, bundleIdentifier: String? = nil) {
        app = if let bundleIdentifier { XCUIApplication(bundleIdentifier: bundleIdentifier) } else { XCUIApplication() }
        element = elementType.toQuery(for: app).matching(identifier: identifier).firstMatch
    }
    
    func `is`(_ condition: ElementCondition, within timeout: TimeInterval = defaultTimeout) -> Bool {
        let predicate = switch condition {
        case .exist: "exists == true"
        case .notExist: "exists == false"
        case .enabled: ""
        case .notEnabled: "isEnabled == false"
        case .hittable: "isHittable == true"
        case .notVisible: "isHittable == false"
        }
        return waitForPredicate(NSPredicate(format: predicate), timeout: timeout)
    }
    
    @discardableResult
    func waitFor(_ timeout: TimeInterval = defaultTimeout) -> Self {
        guard element.waitForExistence(timeout: timeout) else {
            XCTFail("❌ Failed to find '\(element.description)'"); return self
        }
        return self
    }
    
    private func waitForPredicate(_ predicate: NSPredicate, timeout: TimeInterval) -> Bool {
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        return XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
    }
}

enum ElementCondition {
    case exist, enabled, hittable, notExist, notEnabled, notVisible
}

enum ElementType {
    case button, icon, staticText, secureTextField, tabView, textField
    
    func toQuery(for app: XCUIApplication = XCUIApplication()) -> XCUIElementQuery {
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
