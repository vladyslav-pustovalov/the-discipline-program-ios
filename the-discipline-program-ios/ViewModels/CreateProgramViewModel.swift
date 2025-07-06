//
//  CreateProgramViewModel.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 06/07/2025.
//

import Foundation
import KeychainAccess

@Observable
class CreateProgramViewModel {
    private let keychain = Keychain(service: Constants.Bundle.id)
    private(set) var state: LoadingState<Program> = .idle
    var showingAlert = false
    var showingAddProgramSheet = false
    
    private let programService: ProgramService
    
    var authToken: String?
    
    var scheduledDate: Date
    var trainingLevel: TrainingLevel
    var isRestDay: Bool
    var dailyProgram: DailyProgram
    
    init(programService: ProgramService = ProgramService()) {
        authToken = try? keychain.get(Constants.Bundle.tokenKey)
        self.programService = programService
        
        scheduledDate = Date()
        trainingLevel = TrainingLevel(id: 1, name: "Amateur")
        isRestDay = false
        dailyProgram = DailyProgram(dayTrainings: [])
    }
    
    func buildProgram() -> Program {
        //TODO: handle optional dayly program and handle that toggle isRestDay should set dailyProgram to nil
        return Program(id: 1, scheduledDate: scheduledDate, isRestDay: isRestDay, dailyProgram: dailyProgram)
    }
    
    @MainActor
    func saveNewProgram() async {
        state = .loading
        
        guard let authToken else {
            print("authToken is null in create program")
            return
        }
        
        do {
            let result = try await programService.createProgram(authToken: authToken ,program: buildProgram())
            
            switch result {
            case .success(let createdProgram):
                state = .loaded(createdProgram)
            case .failure(let error):
                showingAlert = true
                state = .error(error)
            }
        } catch {
            showingAlert = true
            state = .error(NetworkResponseStatus(statusCode: nil, message: error.localizedDescription))
        }
    }
}
