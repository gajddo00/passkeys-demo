//
//  FittedScrollView.swift
//  Yuck
//
//  Created by Dominika Gajdová on 03.05.2023.
//

import SwiftUI

struct HeightPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 40
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct FittedScrollView<Content: View>: View {
    @State private var contentHeight: CGFloat = 40
    @ViewBuilder var content: Content
    
    var body: some View {
        ScrollView {
            content
                .overlay(
                    GeometryReader { geo in
                        Color.clear.preference(key: HeightPreferenceKey.self, value: geo.size.height)
                    })
        }
        .frame(maxWidth: .infinity)
        .frame(height: contentHeight)
        .onPreferenceChange(HeightPreferenceKey.self) {
            contentHeight = $0
        }
    }
}
