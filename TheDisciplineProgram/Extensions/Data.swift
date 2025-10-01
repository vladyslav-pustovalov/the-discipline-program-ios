//
//  Data.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 01/10/2025.
//

import Foundation

extension Data {
    var jsonString: String? {
        String(data: self, encoding: .utf8)
    }
}
