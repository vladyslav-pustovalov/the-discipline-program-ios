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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    @Previewable @State var user = User.mock
    return EditUserView(user: $user)
}
