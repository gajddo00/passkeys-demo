//
//  SceneManifest.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

struct SceneManifest {
    private enum CodingKeys: String, CodingKey {
        case supportsMultipleScenes = "UIApplicationSupportsMultipleScenes"
        case configurations = "UISceneConfigurations"
    }

    let supportsMultipleScenes: Bool
    let configurations: SceneConfigurationsContainer
}

// MARK: - Decodable
extension SceneManifest: Decodable {}
