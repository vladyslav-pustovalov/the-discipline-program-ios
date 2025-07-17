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
    }
    
    @MainActor
    func loadProgram(for date: Date) {
        state = .loading
        Task {
                        
            guard let userId else {
                Log.error("NIl userId in loadProgram")
                return
            }
            guard let authToken else {
                Log.error("Nil authToken in loadProgram")
                return
            }
            
            let result = try await programService.loadProgram(
                authToken: authToken,
                userId: userId,
                date: date
            )
            
            switch result {
            case .success(let tempProgram):
                program = tempProgram
                state = .loaded(tempProgram)
                
            case .failure(let error):
                if error.code == 403 {
                    AuthViewModel().signOut()
                }
                
                if error.code == 404 {
                    Log.info("Program Not Found")
                    self.program = nil
                }
                
                state = .error(error)
            }
        }
    }
    
    @MainActor
    func loadNextDay() {
        if let date = Calendar.current.date(byAdding: .day, value: 1, to: programDate) {
            loadProgram(for: date)
            programDate = date
        }
    }
    
    @MainActor
    func loadPreviousDay() {
        if let date = Calendar.current.date(byAdding: .day, value: -1, to: programDate) {
            loadProgram(for: date)
            programDate = date
        }
    }
}

