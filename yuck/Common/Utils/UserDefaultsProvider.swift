//
//  UserDefaultsProvider.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import Foundation

enum UserDefaultsProvider {
    enum Key: String {
        case welcomeScreenDisplayed
    }

    @UserDefaultWrapper(.welcomeScreenDisplayed, defaultValue: false)
    public static var welcomeScreenDisplayed: Bool
}
