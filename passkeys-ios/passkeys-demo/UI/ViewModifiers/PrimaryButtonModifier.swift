//
//  PrimaryButtonModifier.swift
//  PasskeysDemo
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import SwiftUI

struct PrimaryButtonModifier: ViewModifier {
    @Environment(\.isEnabled) var isEnabled
    
    let backgroundColor: Color
    let foregroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .bold()
            .frame(maxHeight: 34)
            .padding(.horizontal, 50)
            .padding(.vertical, 5)
            .foregroundColor(isEnabled ? foregroundColor : foregroundColor.opacity(0.5))
            .background(isEnabled ? backgroundColor : backgroundColor.opacity(0.5))
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
