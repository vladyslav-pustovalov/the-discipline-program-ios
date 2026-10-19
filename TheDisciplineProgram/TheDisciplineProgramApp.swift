//
//  TheDisciplineProgramApp.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 19/07/2025.
//

import SwiftUI
import KeychainAccess

@main
struct TheDisciplineProgramApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

#if DEBUG
    init() {
        if ProcessInfo.processInfo.arguments.contains("-ResetState") {
            resetAppState()
        }
    }
    private func resetAppState() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        try? Keychain(service: Constants.Bundle.id).removeAll()
    }
#endif
}

