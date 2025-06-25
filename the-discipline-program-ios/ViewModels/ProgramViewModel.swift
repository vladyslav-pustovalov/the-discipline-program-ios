//
//  ProgramViewModel.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 22/06/2025.
//

import KeychainAccess
import SwiftUI

@Observable class ProgramViewModel {
    let keychain = Keychain(service: Constants.Bundle.id)
    
    var authToken: String?
    var userId: Int?
    var program: Program?
    var programError: NetworkResponseStatus?
    
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
                    }
                    
                case .failure(let error):
                    
                    if error.code == 403 {
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

