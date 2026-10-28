//
//  SystemNotificationAlert.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 19.10.2026.
//

import XCTest

final class SystemNotificationAlert: BaseScreen {
    private lazy var dontAllowBtn = ButtonElement("Don't Allow", bundleIdentifier: springboardIdentifier)
}

//MARK: - Actions

extension SystemNotificationAlert {
    
    func dontAllowIfShown() {
        dontAllowBtn.clickIfShown()
    }
}

//MARK: - Assertions

extension SystemNotificationAlert {
    
}
