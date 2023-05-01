//
//  Color+AppColors.swift
//  Yuck
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import SwiftUI

// swiftlint:disable: force_unwrapping
extension Color {
    static let backgroundColor = Color(uiColor: .backgroundColor)
    static let foregroundColor = Color(uiColor: .foregroundColor)
    static let accentColor = Color(uiColor: .accentColor)
}

extension UIColor {
    static let backgroundColor = RColor.backgroundColor()!
    static let foregroundColor = RColor.foregroundColor()!
    static let accentColor = RColor.accentColor()!
}
