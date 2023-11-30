//
//  Configuration.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import Foundation

struct Configuration: Decodable {
    private enum CodingKeys: String, CodingKey {
        case sceneManifest = "UIApplicationSceneManifest"
        case authDomain = "APP_AUTH_DOMAIN"
        case apiBaseUrl = "API_BASE_URL"
    }
    
    let sceneManifest: SceneManifest?
    let authDomain: String
    let apiBaseUrl: String
}

// MARK: Static properties
extension Configuration {
    static let `default`: Configuration = {
        guard let propertyList = Bundle.main.infoDictionary else {
            fatalError("Unable to get property list.")
        }

        guard let data = try? JSONSerialization.data(withJSONObject: propertyList, options: []) else {
            fatalError("Unable to instantiate data from property list.")
        }

        let decoder = JSONDecoder()

        guard let configuration = try? decoder.decode(Configuration.self, from: data) else {
            fatalError("Unable to decode the Environment configuration file.")
        }

        return configuration
    }()
}
