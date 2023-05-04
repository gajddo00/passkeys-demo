//
//  PrimaryButtonModifier.swift
//  Yuck
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import SwiftUI

struct PrimaryButtonModifier: ViewModifier {
    let backgroundColor: Color
    let foregroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .bold()
            .frame(maxHeight: 34)
            .padding(.horizontal, 50)
            .padding(.vertical, 5)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(12)
            .padding(.bottom, 15)
    }
}

extension View {
    func primaryButtonGray() -> some View {
        self.modifier(PrimaryButtonModifier(
            backgroundColor: .grayColor,
            foregroundColor: .foregroundColor
        ))
    }
    
    func primaryButtonWhite() -> some View {
        self.modifier(PrimaryButtonModifier(
            backgroundColor: .foregroundColor,
            foregroundColor: .backgroundColor
        ))
    }
}
