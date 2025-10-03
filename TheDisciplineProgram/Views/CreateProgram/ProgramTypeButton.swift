//
//  ProgramTypeButton.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 28/09/2025.
//

import SwiftUI

struct ProgramTypeButton: View {
    @Binding var selectedProgramType: ProgramType
    var programType: ProgramType
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Text(text)
                .font(.headline)
                .foregroundColor(programType == selectedProgramType ? Color.white : Color.gray)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(programType == selectedProgramType ? Color.blue : Color.clear)
                .cornerRadius(40)
        })
    }
}

#Preview {
    @Previewable @State var selectedProgramType = ProgramType.generalProgram
    
    return ProgramTypeButton(
        selectedProgramType: $selectedProgramType,
        programType: ProgramType.generalProgram,
        text: "Type"
    ) { }
        .preferredColorScheme(.dark)
}
