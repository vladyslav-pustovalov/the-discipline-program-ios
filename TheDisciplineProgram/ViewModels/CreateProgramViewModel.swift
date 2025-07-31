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
    var showingAlreadyExistsAlert = false
    var alertMessage = ""
    var showingAddProgramSheet = false
    var trainingLevels: [TrainingLevel] = []
    
    private let programService: ProgramService
    private let trainingLevelService: TrainingLevelService
    
    var authToken: String?
    
    var id = 1
    var scheduledDate: Date
    var trainingLevel: TrainingLevel
    var isRestDay: Bool
    var dailyProgram: DailyProgram
    
    init(programService: ProgramService = ProgramService(), trainingLevelService: TrainingLevelService = TrainingLevelService()) {
        
        authToken = try? keychain.get(Constants.Bundle.tokenKey)
        self.programService = programService
        self.trainingLevelService = trainingLevelService
        
        scheduledDate = Date()
        //TODO: get level only from loading, and not hardcoded
        trainingLevel = TrainingLevel(id: 2, name: "Pro")
        isRestDay = false
        dailyProgram = DailyProgram(dayTrainings: [])
    }
    
    private func buildProgram() throws -> Program {
        if !isRestDay {
            guard !dailyProgram.dayTrainings.isEmpty else {
                throw EmptyDailyProgramError()
            }
        }
        
        return Program(id: id, scheduledDate: scheduledDate, trainingLevel: trainingLevel, isRestDay: isRestDay, dailyProgram: isRestDay ? nil : dailyProgram)
    }
    
    @MainActor
    func saveNewProgram() async {
        state = .loading
        
        guard let authToken else {
            Log.error("Nil authToken in create program")
            return
        }
        
        do {
            let result = try await programService.createProgram(authToken: authToken ,program: buildProgram())
            
            switch result {
            case .success(let createdProgram):
                state = .loaded(createdProgram)
                alertMessage = "Program is saved successfully"
                showingAlert = true
                
            case .failure(let error):
                if error.code == 409 {
                    handleAlreadyExistsProgram(error: error)
                    state = .error(error)
                    return
                }
                state = .error(error)
                alertMessage = "Program is not saved. Error: \(error.code), \(error.description)"
                showingAlert = true
            }
        } catch is EmptyDailyProgramError {
            alertMessage = "You can't save non rest day without adding at least one trainig to a program"
            showingAlert = true
            state = .idle
        } catch {
            alertMessage = "Unexpected error during loading saving new program: \(error.localizedDescription)"
            showingAlert = true
            state = .error(NetworkResponseStatus(statusCode: nil, message: error.localizedDescription))
        }
    }
    
    @MainActor
    func updateProgram() async {
        state = .loading
        
        guard let authToken else {
            Log.error(("Nil authToken in update program"))
            return
        }
                
        do {
            let result = try await programService.updateProgram(authToken: authToken ,program: buildProgram())
            
            switch result {
            case .success(let createdProgram):
                state = .loaded(createdProgram)
                alertMessage = "Program is updated successfully"
                showingAlert = true
                
            case .failure(let error):
                state = .error(error)
                alertMessage = "Program is not updated. Error: \(error.code), \(error.description)"
                showingAlert = true
            }
        } catch {
            alertMessage = "Unexpected error during updating program: \(error.localizedDescription)"
            showingAlert = true
            state = .error(NetworkResponseStatus(statusCode: nil, message: error.localizedDescription))
        }
    }
    
    @MainActor
    func loadTrainingLevels() async {
        
        do {
            let result = try await trainingLevelService.loadTrainingLevels()
            
            switch result {
            case .success(let levels):
                trainingLevels = levels
            case .failure(let error):
                alertMessage = "Training levels are not Loaded: \(error.code), \(error.description)"
                showingAlert = true
            }
        } catch {
            alertMessage = "Unexpected error during loading training levels: \(error.localizedDescription)"
            showingAlert = true
        }
    }
    
    private func handleAlreadyExistsProgram(error: NetworkResponseStatus) {
        let stringId = error.httpResponse?.value(forHTTPHeaderField: "PROGRAM_ID")
        if let stringId {
            if let id = Int(stringId) {
                self.id = id
                alertMessage = "The program for this date and this level already exists, update existing program with the new one?"
                showingAlreadyExistsAlert = true
            } else {
                Log.error("Can't parse id from header string value")
            }
        } else {
            Log.error("There is no header with id")
        }
    }
}
