//
//  ProgramViewModel.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 22/06/2025.
//

import KeychainAccess
import SwiftUI

extension ProgramView {
    
    @Observable class ViewModel {
        let keychain = Keychain(service: Constants.Bundle.id)

        private var appState: AppState?
        var authToken: String?
        var userId: Int?
        var programDate: Date
        var program: Program?
        var programError: NetworkResponseStatus?
        
        init(programDate: Date) {
            authToken = try? keychain.get(Constants.Bundle.tokenKey)
            userId = UserDefaults.standard.integer(forKey: Constants.Defaults.userId)
            self.programDate = programDate
            loadProgram(for: programDate)
        }
        
        func setup(_ appState: AppState) {
            self.appState = appState
        }
        
        func loadProgram(for date: Date) {
            Task {
                
                print("Date inside loadProgram: \(date)")
                
                do {
                    guard let userId else {
                        print("Nil userId in loadProgram")
                        return
                    }
                    guard let authToken else {
                        print("Nil authToken in loadProgram")
                        return
                    }
                    let result = try await NetworkManager.shared.loadProgram(
                        authToken: authToken,
                        userId: userId,
                        date: date
                    )
                    
                    switch result {
                    case .success(let tempProgram):
                        print("Program: \(tempProgram.scheduledDate)")
                        await MainActor.run {
                            program = tempProgram
                        }
                    case .failure(let error):
                        if error.code == 403 {
                            await MainActor.run {
                                appState?.isAuthenticated = false
                            }
                            return
                        }
                        if error.code == 404 {
                            print("Program Not Found")
                            await MainActor.run {
                                self.program = nil
                                self.programError = error
                            }
                        }
                        throw error
                    }
                } catch {
                    print("❌ Program failed: \(error)")
                    print("Error message: \(error.localizedDescription)")
                }
            }
        }
        
        func loadNextDay() {
            programDate = Calendar.current.date(byAdding: .day, value: 1, to: programDate)!
            loadProgram(for: programDate)
        }

        func loadPreviousDay() {
            programDate = Calendar.current.date(byAdding: .day, value: -1, to: programDate)!
            loadProgram(for: programDate)
        }
    }
}
