//
//  TabbarCoordinator.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import UIKit

protocol TabBarControllerCoordinator: ViewControllerCoordinator {
    var tabBarController: UITabBarController { get }
}

extension TabBarControllerCoordinator {
    var rootViewController: UIViewController {
        tabBarController
    }
}
