//
//  SavePasswordAlert.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 18.10.2026.
//

import XCTest

final class SavePasswordAlert: BaseScreen {
    private lazy var notNowBtn = ButtonElement("Not Now")
}

//MARK: - Actions

extension SavePasswordAlert {
    
    func clickNotNow() {
        notNowBtn.click()
    }
}

//MARK: - Assertions

extension SavePasswordAlert {
    
}
