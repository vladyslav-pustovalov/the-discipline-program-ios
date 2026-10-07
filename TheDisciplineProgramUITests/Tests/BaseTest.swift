//
//  TheDisciplineProgramUITests.swift
//  TheDisciplineProgramUITests
//
//  Created by Vladyslav Pustovalov on 05.10.2026.
//

import XCTest

class BaseTest: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchWithCleanState()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }
}
