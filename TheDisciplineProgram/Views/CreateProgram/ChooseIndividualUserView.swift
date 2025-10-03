//
//  ChooseIndividualUserView.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 28/09/2025.
//

import SwiftUI

struct ChooseIndividualUserView: View {
    @Environment(CreateProgramViewModel.self) var createProgramViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        @Bindable var createProgramViewModel = createProgramViewModel

        VStack {
            if let users = createProgramViewModel.users {
                let filteredUsers = users.filter { user in
                    createProgramViewModel.usersSearchText.isEmpty ||
                    user.visibleName
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .localizedCaseInsensitiveContains(createProgramViewModel.usersSearchText)
                }
                
                List(filteredUsers) { user in
                    Button(user.visibleName) {
                        createProgramViewModel.individualUser = user
                        dismiss()
                    }
                }
                .searchable(text: $createProgramViewModel.usersSearchText)
                
            }
        }
        .navigationTitle("Individual Users")
        .onAppear {
            Task {
                await createProgramViewModel.loadIndividualUsers()
            }
        }
    }
}

#Preview {
    ChooseIndividualUserView()
}
