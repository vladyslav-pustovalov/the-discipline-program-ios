//
//  LoadingState.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 25/06/2025.
//

import Foundation

enum LoadingState<Value: Equatable>: Equatable {
    case idle
    case loading
    case loaded(Value)
    case error(NetworkResponseStatus)
}
