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
        Form {
            ForEach(addTrainingViewModel.dayTraining.blocks.indices, id: \.self) { index in
                Section {
                    ForEach(addTrainingViewModel.dayTraining.blocks[index].exercises.indices, id: \.self) { exerciseIndex in
                        Text(addTrainingViewModel.dayTraining.blocks[index].exercises[exerciseIndex])
                    }
                } header: {
                    NavigationLink("\(addTrainingViewModel.dayTraining.blocks[index].name)") {
                        AddBlockView(block: addTrainingViewModel.dayTraining.blocks[index]) { block in
                            addTrainingViewModel.dayTraining.blocks[index] = block
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
        .safeAreaInset(edge: .bottom) {
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
