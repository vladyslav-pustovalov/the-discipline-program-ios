//
//  ProgramTypeButton.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 28/09/2025.
//

import SwiftUI

struct ProgramTypeSelector: View {
    @State private var createProgramViewModel: CreateProgramViewModel
    
    init(program: Program? = nil, navigationTitle: String? = nil) {
        self._createProgramViewModel = State(initialValue: CreateProgramViewModel(program: program, navigationTitle: navigationTitle))
    }
    
    var body: some View {
        HStack {
            
        }
    }
}

#Preview {
    ProgramTypeButton()
}
