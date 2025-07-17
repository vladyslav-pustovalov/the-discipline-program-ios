//
//  BaseEncoder.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 28/06/2025.
//

import Foundation

final class BaseEncoder: JSONEncoder, @unchecked Sendable {
    override init() {
        super.init()
        super.dateEncodingStrategy = .formatted(Constants.Formatter.dateFormatter)
        super.outputFormatting = .prettyPrinted
    }
}
