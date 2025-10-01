//
//  ProgramTypeButton.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 28/09/2025.
//

import SwiftUI

struct ProgramTypeButton: View {
    @Binding var isSelected: Bool
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Text(text)
                .font(.headline)
                .foregroundColor(isSelected ? Color.white : Color.gray)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(isSelected ? Color.blue : Color.white)
                .cornerRadius(40)
        })
    }
}

#Preview {
    @Previewable @State var isSelected = true
    
    return ProgramTypeButton(isSelected: $isSelected, text: "Base Button") {
        
    }
}
