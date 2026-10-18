//
//  XCUIApplication+extention.swift
//  TheDisciplineProgramUITests
//
//  Created by Vladyslav Pustovalov on 05.10.2026.
//

import XCTest

extension XCUIApplication {
    
    func uninstall(name: String? = nil) {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        
        var appName: String {
            if let name { return name }
            else {
                let uiTestRunnerName = Bundle.main.infoDictionary?["CFBundleName"] as! String
                return uiTestRunnerName.replacingOccurrences(of: "UITests-Runner", with: "")            }
        }
        
        XCTContext.runActivity(named: "🚮 Removing app -> \(String(describing: name))") { [self] _ in
            let appIcon = springboard.icons[appName].firstMatch
            
            if appIcon.waitForExistence(timeout: defaultTimeout) {
                appIcon.press(forDuration: 1.3)
            } else {
                XCTFail("❌ Failed to find app icon named \(appName)")
            }
            
            let removeAppButton = springboard.buttons["com.apple.springboardhome.application-shortcut-item.remove-app"].firstMatch
            if removeAppButton.waitForExistence(timeout: defaultTimeout) {
                removeAppButton.tap()
            } else {
                XCTFail("❌ Failed to find 'Remove App'")
            }
            
            let deleteAppButton = springboard.alerts.buttons["Delete App"].firstMatch
            if deleteAppButton.waitForExistence(timeout: defaultTimeout) {
                deleteAppButton.tap()
            } else {
                XCTFail("❌ Failed to find 'Delete App'")
            }
            
            let finalDeleteButton = springboard.alerts.buttons["Delete"].firstMatch
            if finalDeleteButton.waitForExistence(timeout: defaultTimeout) {
                finalDeleteButton.tap()
            } else {
                XCTFail("❌ Failed to find 'Delete'")
            }
        }
    }
}

enum MockNotificationStatus {
    case notDetermined
    case authorized
    case denied

    var argument: String {
        switch self {
        case .notDetermined: return "-MockNotificationNotDetermined"
        case .authorized: return "-MockNotificationAuthorized"
        case .denied: return "-MockNotificationDenied"
        }
    }
}

extension XCUIApplication {
    func launchWithCleanState(
        notificationStatus: MockNotificationStatus? = nil,
        autoResolvePermissionRequest: Bool? = nil
    ) {
        launchArguments.append("-ResetState")

        if let status = notificationStatus {
            launchArguments.append(status.argument)
        }

        if let autoResolve = autoResolvePermissionRequest {
            launchArguments.append(autoResolve ? "-MockNotificationRequestGranted" : "-MockNotificationRequestDenied")
        }

        launch()
    }

    /// Attempts to dismiss the system "Save Password" alert without saving, if present on SpringBoard.
    /// - Parameter timeout: Maximum time to wait for the alert button to appear.
    /// - Returns: `true` if the alert was found and dismissed, `false` otherwise.
    @discardableResult
    func dismissSavePasswordAlertIfPresent(timeout: TimeInterval = 5.0) -> Bool {
        let springboard = XCUIApplication()
        let notNowButtons = ["Not Now"]

        for title in notNowButtons {
            let button = springboard.buttons[title]
            if button.waitForExistence(timeout: timeout) {
                button.tap()
                return true
            }
        }
        return false
    }
}
