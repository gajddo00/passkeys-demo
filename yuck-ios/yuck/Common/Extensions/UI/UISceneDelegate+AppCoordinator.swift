//
//  UISceneDelegate+AppCoordinator.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import UIKit

extension UISceneDelegate {
    var appCoordinator: AppCoordinating {
        guard let delegate = UIApplication.shared.delegate as? AppCoordinatorContaining else {
            fatalError("Application delegate doesn't implement `AppCoordinatorDelegating` protocol")
        }

        return delegate.coordinator
    }
}
