//
//  the_discipline_program_iosApp.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftUI

@main
struct the_discipline_program_iosApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
