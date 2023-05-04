//
//  PrimaryTextFieldModifier.swift
//  Yuck
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import SwiftUI

struct PrimaryTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.foregroundColor, lineWidth: 2)
            )
    }
}

extension View {
    func primaryTextField() -> some View {
        self.modifier(PrimaryTextFieldModifier())
    }
}
