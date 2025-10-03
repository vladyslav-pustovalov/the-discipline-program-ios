//
//  ProgramService.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 25/06/2025.
//

import Foundation

final class ProgramService: NetworkService {
    
    private func getProgramURLBy(_ type: ProgramType) -> String {
        switch type {
        case .generalProgram:
            "\(baseURL)/generalProgram"
        case .individualProgram:
            "\(baseURL)/individualProgram"
        }
    }
    
    func loadProgram(authToken: String, userId: Int, date: Date) async throws -> Result<Program, NetworkResponseStatus> {
        let stringDate = Constants.Formatter.dateFormatter.string(from: date)
        let stringURL = "\(baseURL)/program?userId=\(userId)&scheduledDate=\(stringDate)"
        let headers = [
            "Content-Type": "application/json",
            "Authorization": authToken
        ]
        
        let result = try await performRequest(
            stringURL: stringURL,
            method: Constants.HTTPMethods.get,
            headers: headers,
            body: nil
        )
        
        switch result {
        case .success(let data):
            do {
                let program = try BaseDecoder().decode(Program.self, from: data)
                return .success(program)
            } catch {
                Log.error("Error during program decoding: \(error.localizedDescription)")
                return .failure(NetworkResponseStatus(statusCode: 422, message: "Error during program data decoding"))
            }
        case .failure(let status):
            return .failure(status)
        }
    }
    
    func createProgram(authToken: String, type: ProgramType, program: Program) async throws -> Result<Program, NetworkResponseStatus> {
        
        let stringURL = getProgramURLBy(type)
        let headers = [
            "Content-Type": "application/json",
            "Authorization": authToken
        ]
        
        let body = try BaseEncoder().encode(program)
        
        Log.info("Creating \(type) program with body: \(String(describing: body.jsonString))")
        
        let result = try await performRequest(
            stringURL: stringURL,
            method: Constants.HTTPMethods.post,
            headers: headers,
            body: body
        )
        
        switch result {
        case .success(let data):
            do {
                let program = try BaseDecoder().decode(Program.self, from: data)
                return .success(program)
            } catch {
                Log.error("Error during program decoding: \(error.localizedDescription)")
                return .failure(NetworkResponseStatus(statusCode: 422, message: "Error during program data decoding"))
            }
        case .failure(let status):
            return .failure(status)
        }
    }
    
    func updateProgram(authToken: String, type: ProgramType, program: Program) async throws -> Result<Program, NetworkResponseStatus> {
        let stringURL = getProgramURLBy(type)
        let headers = [
            "Content-Type": "application/json",
            "Authorization": authToken
        ]
        
        let body = try BaseEncoder().encode(program)
        
        let result = try await performRequest(
            stringURL: stringURL,
            method: Constants.HTTPMethods.put,
            headers: headers,
            body: body
        )
        
        switch result {
        case .success(let data):
            do {
                let program = try BaseDecoder().decode(Program.self, from: data)
                return .success(program)
            } catch {
                Log.error("Error during program decoding: \(error.localizedDescription)")
                return .failure(NetworkResponseStatus(statusCode: 422, message: "Error during program data decoding"))
            }
        case .failure(let status):
            return .failure(status)
        }
    }
}
