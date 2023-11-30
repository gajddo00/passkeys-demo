//
//  ViewControllerCoordinator.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import UIKit

/// A coordinator protocol which contains `rootViewController`.
/// UIViewController-based coordinators confirm to this.
/// Coordinators which handles transition inside custom content view controllers (view controllers with childVCs) should conform to this.
/// For `UINavigationController` or `UITabBarController` based coordinators, use `NavigationControllerCoordinator` or `TabBarControllerCoordinator` respectively
protocol ViewControllerCoordinator: Coordinator {
    var rootViewController: UIViewController { get }
}

// MARK: - Presentation
extension ViewControllerCoordinator {
    func handlePresentation(viewController: UIViewController, type: PresentationType) {
        switch type {
        case .push, .replace: break
        case let .present(presentationType, animated):
            viewController.modalPresentationStyle = presentationType
            rootViewController.present(viewController, animated: animated)
        }
    }

    func handlePresentation(
        from source: UIViewController,
        of viewController: UIViewController,
        type: PresentationType
    ) {
        switch type {
        case .push, .replace: break
        case let .present(presentationType, animated):
            viewController.modalPresentationStyle = presentationType
            source.present(viewController, animated: animated)
        }
    }
}
