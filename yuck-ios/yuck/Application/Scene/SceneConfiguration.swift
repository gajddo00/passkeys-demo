//
//  SceneConfiguration.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

struct SceneConfiguration {
    private enum CodingKeys: String, CodingKey {
        case name = "UISceneConfigurationName"
        case delegateClassName = "UISceneDelegateClassName"
    }

    let delegateClassName: String
    let name: String
}

// MARK: - Decodable
extension SceneConfiguration: Decodable {}

// MARK: - Hashable
extension SceneConfiguration: Hashable {}
