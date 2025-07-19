//
//  BaseDecoder.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 28/06/2025.
//

import Foundation

final class BaseDecoder: JSONDecoder, @unchecked Sendable {
    override init() {
        super.init()
        super.dateDecodingStrategy = .formatted(Constants.Formatter.dateFormatter)
    }
}
