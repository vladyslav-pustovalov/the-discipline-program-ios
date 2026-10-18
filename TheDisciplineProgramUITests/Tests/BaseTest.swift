//
//  TheDisciplineProgramUITests.swift
//  TheDisciplineProgramUITests
//
//  Created by Vladyslav Pustovalov on 05.10.2026.
//

import XCTest

class BaseTest: XCTestCase {
    let app = XCUIApplication()
    private var interruptionMonitors: [NSObjectProtocol] = []

    override func setUpWithError() throws {
        continueAfterFailure = false
        addSystemNotificationInterruptionMonitor()
        app.launchWithCleanState()
    }

    override func tearDownWithError() throws {
        for monitor in interruptionMonitors {
            removeUIInterruptionMonitor(monitor)
        }
        interruptionMonitors.removeAll()
        app.terminate()
    }

    /// Adds a UI interruption monitor to automatically handle system notification alerts.
    /// - Parameter allow: If `true`, taps "Allow" (or "OK"). If `false`, taps "Don't Allow".
    @discardableResult
    func addSystemNotificationInterruptionMonitor(allow: Bool = true) -> NSObjectProtocol {
        let monitor = addUIInterruptionMonitor(withDescription: "System Notification Permission Alert") { alert in
            let allowButtonTitles = ["Allow", "OK"]
            let denyButtonTitles = ["Don't Allow", "Don’t Allow"]
            let candidateTitles = allow ? allowButtonTitles : denyButtonTitles

            for title in candidateTitles {
                let button = alert.buttons[title]
                if button.exists {
                    button.tap()
                    return true
                }
            }
            return false
        }
        interruptionMonitors.append(monitor)
        return monitor
    }
}
