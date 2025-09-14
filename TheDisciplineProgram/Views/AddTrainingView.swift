//
//  AddTrainingView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 06/07/2025.
//

import SwiftUI

struct AddTrainingView: View {
    @Environment(\.dismiss) var dismiss
    @State var addTrainingViewModel: AddTrainingViewModel
    
    var onAdd: (DayTrainig) -> Void
    
    init(dayTraining: DayTrainig? = nil, trainingNumber: Int ,onAdd: @escaping (DayTrainig) -> Void) {
        self._addTrainingViewModel = State(initialValue: AddTrainingViewModel(trainingNumber: trainingNumber))
        self.onAdd = onAdd
        if let dayTraining {
            addTrainingViewModel.dayTraining = dayTraining
        }
    }
    
    var body: some View {
        VStack {
            Form {
                ForEach(addTrainingViewModel.dayTraining.blocks.indices, id: \.self) { blockIndex in
                    
                    Safe($addTrainingViewModel.dayTraining.blocks, index: blockIndex) { blockBinding in
                        
                        Section {
                            //wrapping ForEach into VStack for it being as one item when swipe onDelete
                            VStack(alignment: .leading, spacing: 6) {
                                
                                ForEach(blockBinding.wrappedValue.exercises.indices, id: \.self) { exerciseIndex in
                                    Safe(blockBinding.exercises, index: exerciseIndex) { exerciseBinding in
                                        Text(exerciseBinding.wrappedValue)
                                            .frame(maxWidth: .infinity, alignment: .leading)

                                        // Add divider except after the last exercise text
                                        if exerciseIndex < blockBinding.wrappedValue.exercises.count - 1 {
                                            Divider()
                                        }
                                    }
                                }
                            }
                        } header: {
                            NavigationLink("\(blockBinding.wrappedValue.name)") {
                                AddBlockView(block: blockBinding.wrappedValue) { newBlock in
                                    addTrainingViewModel.dayTraining.blocks[blockIndex] = newBlock
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: addTrainingViewModel.deleteBlock)
                
                NavigationLink("Add Block to training") {
                    AddBlockView { block in
                        addTrainingViewModel.dayTraining.blocks.append(block)
                    }
                }
            }
            
            Button {
                onAdd(addTrainingViewModel.dayTraining)
                dismiss()
            } label: {
                Text("Save Training")
                    .fontWeight(.medium)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(addTrainingViewModel.isDayTrainingEmpty ?
                                        Color.gray.opacity(0.5) :
                                        Color.blue.opacity(0.5),
                                    lineWidth: 2)
                    )
                    .foregroundColor(addTrainingViewModel.isDayTrainingEmpty ? .gray : .blue)
            }
            .disabled(addTrainingViewModel.isDayTrainingEmpty)
            .padding()
        }
        .navigationTitle("Add Training to day")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton()
        }
    }
}

#Preview {
    AddTrainingView(trainingNumber: 1) { _ in }
}
