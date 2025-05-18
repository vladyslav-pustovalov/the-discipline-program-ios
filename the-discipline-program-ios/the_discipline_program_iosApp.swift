//
//  the_discipline_program_iosApp.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftData
import SwiftUI

@main
struct the_discipline_program_iosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
        .modelContainer(for: Program.self)
    }
}
