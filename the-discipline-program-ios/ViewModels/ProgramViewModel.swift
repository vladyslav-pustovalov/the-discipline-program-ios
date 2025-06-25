//
//  ProgramViewModel.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 22/06/2025.
//

import KeychainAccess
import SwiftUI

@Observable
class ProgramViewModel {
    private let keychain = Keychain(service: Constants.Bundle.id)
    private(set) var state: LoadingState<Program> = .idle
    
    var authToken: String?
    var userId: Int?
    var program: Program?
    
    private let programService: ProgramService
    var programDate: Date
    
    init(programService: ProgramService = ProgramService(), programDate: Date) {
        self.programService = programService
        self.programDate = programDate
        
        authToken = try? keychain.get(Constants.Bundle.tokenKey)
        userId = UserDefaults.standard.integer(forKey: Constants.Defaults.userId)
        
        loadProgram(for: programDate)
    }
    
    func loadProgram(for date: Date) {
        state = .loading
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
                
                let result = try await programService.loadProgram(
                    authToken: authToken,
                    userId: userId,
                    date: date
                )
                
                switch result {
                case .success(let tempProgram):
                    print("Program: \(tempProgram.scheduledDate)")
                    await MainActor.run {
                        program = tempProgram
                        state = .loaded(tempProgram)
                    }
                    
                case .failure(let error):
                    if error.code == 403 {
                        
                    }
                    
                    if error.code == 404 {
                        print("Program Not Found")
                        await MainActor.run {
                            self.program = nil
                        }
                    }
                    state = .error(error)
                }
            } catch {
                print("❌ Program failed: \(error)")
                print("Error message: \(error.localizedDescription)")
            }
        }
    }
    
    func loadNextDay() {
        if let date = Calendar.current.date(byAdding: .day, value: 1, to: programDate) {
            loadProgram(for: date)
            programDate = date
        }
    }
    
    func loadPreviousDay() {
        if let date = Calendar.current.date(byAdding: .day, value: -1, to: programDate) {
            loadProgram(for: date)
            programDate = date
        }
    }
}

