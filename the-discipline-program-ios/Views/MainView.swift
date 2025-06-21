//
//  MainView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftData
import SwiftUI

struct MainView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var programs: [Program]
    @Query var users: [User]
    
    @State var isAuthenticate = false
    @State var authToken: String? = UserDefaults.standard.string(forKey: Constants.Defaults.accessToken)
    @State var userId: Int? = UserDefaults.standard.integer(forKey: Constants.Defaults.userId)
    @State var program: Program?
    @State var user: User? = User.mock
    
    var body: some View {
        if authToken != nil {
            LoginView(authToken: $authToken, userId: $userId, isAuthenticated: $isAuthenticate)
        } else {
            TabView {
                NavigationStack {
                    ProgramView(program: program)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Previous day") {
                                    let nextDay = Calendar.current.date(byAdding: .day, value: -1, to: program?.scheduledDate ?? Date())
                                    print("Previous day: \(nextDay)")
                                    loadProgram(for: nextDay)
                                }
                            }
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Next day") {
                                    let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: program?.scheduledDate ?? Date())
                                    print("Next day: \(nextDay)")
                                    loadProgram(for: nextDay)
                                }
                            }
                        }
                }
                .tabItem {
                    Label("Program", systemImage: "list.dash")
                }
                
                NavigationStack {
                    VStack {
                        UserView(user: user)
                        
                        Button("Sign Out", role: .destructive, action: signOut)
                            .buttonStyle(.bordered)
                            .padding(5)
                        
                        Rectangle()
                            .frame(height: 0.2)
                            .opacity(0.5)
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Edit") {
                            }
                        }
                    }
                }
                .tabItem {
                    Label("User", systemImage: "person.circle")
                }
            }
            .onAppear {
                let date = Constants.Formatter.dateFormatter.date(from: "2024-06-07")
                loadProgram(for: date)
            }
            .onAppear(perform: loadUser)
            .background(.gray)
        }
    }
    
    func loadProgram(for day: Date?) {
        Task {
            
            var date = day ?? Date.now
            print("Date inside loadProgram: \(date)")
            
            do {
                guard let userId else { return }
                guard let authToken else { return }
                let result = try await NetworkManager.shared.loadProgram(
                    authToken: authToken,
                    userId: userId,
                    date: date
                )
                
                switch result {
                case .success(let tempProgram):
                    print("Program: \(tempProgram.scheduledDate)")
                    program = tempProgram
                    modelContext.insert(tempProgram)
                case .failure(let error):
                    if error.code == 403 {
                        signOut()
                        return
                    }
                    if error.code == 404 {
                        return
                    }
                    throw error
                }
            } catch {
                program = programs.filter { $0.scheduledDate == date }.first
                print("❌ Program failed: \(error)")
                print("Error message: \(error.localizedDescription)")
            }
        }
    }
    
    func loadUser() {
        Task {
            guard let userId else { return }
            guard let authToken else { return }
            
            do {
                let result = try await NetworkManager.shared.loadUser(
                    authToken: authToken,
                    userId: userId
                )
                
                switch result {
                case .success(let tempUser):
                    
                    if let level = tempUser.trainingLevel {
                        print("User: \(tempUser.login), \(level.id), \(level.name)")

                    } else {
                        print("Level is null")
                    }
                    
                    user = tempUser
                    modelContext.insert(tempUser)
                case .failure(let error):
                    if error.code == 403 {
                        signOut()
                    }
                    throw error
                }
            } catch {
                user = users.filter { $0.id == userId }.first
                print("❌ User failed: \(error)")
                print("Error message: \(error.localizedDescription)")
            }
            
        }
    }
    
    func signOut() {
        isAuthenticate = false
        authToken = nil
        if let program {modelContext.delete(program)}
        if let user {modelContext.delete(user)}
    }
}

#Preview {
    MainView()
}
