//
//  String.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 31/07/2025.
//

import Foundation

extension String {
    var isValidPassword: Bool {
        guard self.count >= 6 && self.count <= 32 else { return false }
        
        let disallowedCharacters = CharacterSet(charactersIn: "\"'`\\/<>{}[]();")
        if self.rangeOfCharacter(from: disallowedCharacters) != nil {
            return false
        }
        
        let hasUppercase = self.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = self.range(of: "[a-z]", options: .regularExpression) != nil
        let hasDigit     = self.range(of: "\\d", options: .regularExpression) != nil
        let hasSpecial = self.range(of: "[!@#$%^&*_+=|~?:\\[\\]{}.\\-]", options: .regularExpression) != nil
        
        return hasUppercase && hasLowercase && hasDigit && hasSpecial
    }
    
    var passwordValidationMessage: String? {
        if self.isEmpty { return nil }
        
        if self.count < 6 || self.count > 32 {
            return "Password must be 6–32 characters long."
        }
        
        let disallowedCharacters = CharacterSet(charactersIn: "\"'`\\/<>{}[]()\n\r\t ")
        if self.rangeOfCharacter(from: disallowedCharacters) != nil {
            return "Password contains disallowed characters (e.g. \", ', \\, <, >, {, }, [, ], (, ), `, or space)."
        }
        
        if self.range(of: "[A-Z]", options: .regularExpression) == nil {
            return "Password must contain at least one uppercase letter."
        }
        
        if self.range(of: "[a-z]", options: .regularExpression) == nil {
            return "Password must contain at least one lowercase letter."
        }
        
        if self.range(of: "\\d", options: .regularExpression) == nil {
            return "Password must contain at least one digit."
        }
        
        if self.range(of: "[!@#$%^&*()_+=|~?:\\[\\]{}.\\-]", options: .regularExpression) == nil {
            return "Password must contain at least one special character (e.g. !@#$%^&*)."
        }
        
        return nil
    }
}
