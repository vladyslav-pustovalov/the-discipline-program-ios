//
//  MainView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftUI

struct MainView: View {
    @State var isAuthenticate = false
    @State var authToken: String?
    @State var program: Program? = Program.mock
    
    var body: some View {
        if isAuthenticate {
            LoginView(authToken: $authToken, isAuthenticated: $isAuthenticate)
        } else {
            TabView {
                NavigationStack {
                    ProgramView(program: program)
                }
                .tabItem {
                    Label("Program", systemImage: "list.dash")
                }
                
                UserView()
                    .tabItem {
                        Label("User", systemImage: "person.circle")
                    }
            }
            .onAppear() {
                Task {
                    await loadProgram()
                }
            }
        }
    }
    
    func loadProgram() async {
        guard let url = URL(string: "http://127.0.0.1:8080/api/v1/program/1") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        request.setValue(
            authToken,
            forHTTPHeaderField: "Authorization"
        )
        
        let session = URLSession.shared
        
        
        print("Request: \(request)")
        
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Known error: \(error)")
            } else if let data = data {
                print("Data: \(data)")
                if let decodedResponse = try? JSONDecoder().decode(Program.self, from: data) {
                    program = decodedResponse
                    print("Decoded: \(decodedResponse)")
                } else {
                    print("Cant decode")
                }
            } else {
                print("Unknown error")
            }
        }.resume()
    }
}

#Preview {
    MainView()
}
