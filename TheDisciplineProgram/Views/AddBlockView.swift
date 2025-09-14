//
//  AddBlockView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 06/07/2025.
//

import SwiftUI

struct AddBlockView: View {
    @Environment(\.dismiss) var dismiss
    @State var addBlockViewModel: AddBlockViewModel
    
    var onAdd: (Block) -> Void
    
    init(block: Block? = nil, onAdd: @escaping (Block) -> Void) {
        self._addBlockViewModel = State(initialValue: AddBlockViewModel())
        self.onAdd = onAdd
        if let block {
            addBlockViewModel.block = block
        }
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Block name")) {
                    TextField(
                        "Enter block name",
                        text: $addBlockViewModel.block.name,
                        axis: .vertical
                    )
                }
                
                Section(header: Text("Exercises")) {
                    ForEach(addBlockViewModel.block.exercises.indices, id: \.self) { index in
                        Safe($addBlockViewModel.block.exercises, index: index) { binding in
                            VStack(alignment: .leading) {
                                Text("Exercise \(index + 1)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                TextEditor(text: binding)
                                .frame(minHeight: 80)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete(perform: addBlockViewModel.deleteExercise)
                    
                    HStack {
                        TextField("New exercise", text: $addBlockViewModel.newExercise)
                        Button(action: addBlockViewModel.addExercise) {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(addBlockViewModel.newExercise.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
        }
        .navigationTitle("Edit Block")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                EditButton()
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onAdd(addBlockViewModel.block)
                    dismiss()
                }
                .disabled(addBlockViewModel.isBlockNameEmpty)
            }
        }
    }
}

#Preview {
    AddBlockView() { _ in }
}
