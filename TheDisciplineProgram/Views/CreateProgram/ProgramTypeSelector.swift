//
//  ProgramTypeSelector.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 28/09/2025.
//

import SwiftUI

struct ProgramTypeSelector: View {
    @Environment(CreateProgramViewModel.self) var createProgramViewModel
    @Namespace private var selectorNamespace

    var body: some View {
        @Bindable var createProgramViewModel = createProgramViewModel

        HStack(spacing: 0) {
            ForEach([ProgramType.generalProgram, ProgramType.individualProgram], id: \.self) { type in
                ZStack {
                    if createProgramViewModel.programType == type {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.blue)
                            .matchedGeometryEffect(id: "selector", in: selectorNamespace)
                            .frame(height: 60)
                    }
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            createProgramViewModel.changeProgramType(to: type)
                        }
                    }) {
                        Text(type == .generalProgram ? "General" : "Individual")
                            .font(.headline)
                            .foregroundColor(
                                createProgramViewModel.programType == type ?
                                    Color.white : Color.blue
                            )
                            .frame(maxWidth: .infinity, maxHeight: 60)
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.blue.opacity(0.5), lineWidth: 2)
        )
        .cornerRadius(30)
        .padding(.horizontal, 30)
    }
}

#Preview {
    ProgramTypeSelector()
        .environment(CreateProgramViewModel(program: nil, navigationTitle: nil))
}
