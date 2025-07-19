//
//  LoadingView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 25/06/2025.
//

import SwiftUI

struct LoadingView<Value: Equatable, Content: View, ErrorContent: View>: View {
    let state: LoadingState<Value>
    @ViewBuilder let content: (Value) -> Content
    @ViewBuilder let errorContent: (NetworkResponseStatus) -> ErrorContent
    
    init(
        state: LoadingState<Value>,
        @ViewBuilder content: @escaping (Value) -> Content,
        @ViewBuilder errorContent: @escaping (NetworkResponseStatus) -> ErrorContent
    ) {
        self.state = state
        self.content = content
        self.errorContent = errorContent
    }
    
    var body: some View {
        switch state {
        case .idle:
            Color.clear
        case .loading:
            ProgressView()
        case .loaded(let value):
            content(value)
        case .error(let error):
            errorContent(error)
        }
    }
}

//#Preview {
//    LoadingView()
//}
