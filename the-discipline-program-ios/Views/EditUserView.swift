//
//  EditUserView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 21/06/2025.
//

import SwiftUI

struct EditUserView: View {
    @Binding var user: User
    
    var body: some View {
        
    }
}

#Preview {
    @Previewable @State var user: User = User.mock
    return EditUserView(user: $user)
}
