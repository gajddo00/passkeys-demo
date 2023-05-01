//
//  View+FirstAppear.swift
//  Yuck
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import SwiftUI

private struct OnFirstAppearViewModifier: ViewModifier {
    @State private var viewDidAppear = false

    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if !viewDidAppear {
                viewDidAppear = true

                action?()
            }
        }
    }
}

extension View {
    func onFirstAppear(perform action: (() -> Void)? = nil) -> some View {
        modifier(
            OnFirstAppearViewModifier(perform: action)
        )
    }
}
