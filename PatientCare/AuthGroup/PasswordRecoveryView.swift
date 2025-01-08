//
//  PasswordRecoveryView.swift
//  PatientCare
//
//  Created by Faheem Ahmed on 03/01/2025.
//

import SwiftUI

struct PasswordRecoveryView: View {
    
    @Binding var showAuthView: Bool
    
    var body: some View {
        Text("Recover your password")
    }
}

#Preview {
    PasswordRecoveryView(showAuthView: .constant(true))
}
