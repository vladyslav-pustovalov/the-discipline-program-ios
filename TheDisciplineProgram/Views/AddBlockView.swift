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
                        VStack(alignment: .leading) {
                            Text("Exercise \(index + 1)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            TextEditor(text: Binding(
                                get: { addBlockViewModel.block.exercises[index] },
                                set: { addBlockViewModel.block.exercises[index] = $0 }
                            ))
                            .frame(minHeight: 80)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                        }
                        .padding(.vertical, 4)
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
            
            Button {
                onAdd(addBlockViewModel.block)
                dismiss()
            } label: {
                Text("Save Block")
                    .fontWeight(.medium)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(addBlockViewModel.isBlockNameEmpty ?
                                        Color.gray.opacity(0.5) :
                                        Color.blue.opacity(0.5),
                                    lineWidth: 2)
                    )
                    .foregroundColor(addBlockViewModel.isBlockNameEmpty ? .gray : .blue)
            }
            .disabled(addBlockViewModel.isBlockNameEmpty)
            .padding()
        }
        .navigationTitle("Edit Block")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton()
        }
    }
}

#Preview {
    AddBlockView() { _ in }
}
