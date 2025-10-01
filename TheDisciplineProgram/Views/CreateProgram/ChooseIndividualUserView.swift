//
//  ChooseIndividualUserView.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 28/09/2025.
//

import SwiftUI

struct ChooseIndividualUserView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(CreateProgramViewModel.self) var createProgramViewModel
    
    var body: some View {
        @Bindable var createProgramViewModel = createProgramViewModel

        VStack {
            if let users = createProgramViewModel.users {
                
                List(users) { user in
                    Button(user.visibleName) {
                        createProgramViewModel.individualUser = user
                        dismiss()
                    }
                }
                
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
    ChooseIndividualUserView(createProgramViewModel: CreateProgramViewModel(program: nil ,navigationTitle: nil))
}
