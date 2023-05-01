//
//  AppDelegate.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, AppCoordinatorContaining {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var coordinator: AppCoordinating!

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        coordinator = AppCoordinator()
        coordinator.start()
        return true
    }
}

// MARK: UISceneSession Lifecycle
extension AppDelegate {
    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        guard let name = Configuration.default.sceneManifest?.configurations.applicationScenes.first?.name else {
            fatalError("No scene configuration")
        }

        return UISceneConfiguration(name: name, sessionRole: connectingSceneSession.role)
    }
}
