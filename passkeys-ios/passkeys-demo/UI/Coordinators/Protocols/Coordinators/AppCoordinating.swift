//
//  AppCoordinating.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import UIKit

protocol AppCoordinating: Coordinator {
    func didLaunchScene<Coordinator: SceneCoordinating>(_ scene: UIScene, window: UIWindow) -> Coordinator

    func didDisconnectScene(_ scene: UIScene)
}
