//
//  NavigationControllerCoordinator.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import UIKit

/// Every coordinator contains a navigation controller and a root view controller that defines the first
/// controller in the coordinator hierarchy.
protocol NavigationControllerCoordinator: ViewControllerCoordinator {
    var navigationController: UINavigationController { get }
}

// MARK: - Presentation
/// Handlers for a navigation flow both for viewController and coordinator.
extension NavigationControllerCoordinator {
    /// Handles presentation of a given view controller.
    /// - Parameters:
    ///   - viewController: The view controller being presented.
    ///   - type: The presentation type.
    func show(viewController: UIViewController, type: PresentationType, completion: (() -> Void)? = nil) {
        switch type {
        case let .push(animated):
            navigationController.pushViewController(viewController, animated: animated)
            completion?()

        case let .present(presentationType, animated):
            viewController.modalPresentationStyle = presentationType

            if let presentedController = navigationController.presentedViewController {
                presentedController.present(viewController, animated: animated, completion: completion)
            } else {
                navigationController.present(viewController, animated: animated, completion: completion)
            }

        case let .replace(animated):
            navigationController.setViewControllers([viewController], animated: animated)
            completion?()
        }
    }

    /// There are multiple presenting coordinator modes to have in mind:
    /// 1. Presenting a coordinator - needs a new navigation controller
    /// 2. Pushing a coordinator - needs an existing navigation controller
    /// - Parameters:
    ///   - coordinator: The coordinator being presented.
    ///   - type: The presentation type of the coordinator.
    ///   - startType: The presentation type of the coordinator's rootViewController.
    func show(
        coordinator: NavigationControllerCoordinator,
        type: PresentationType,
        startType: PresentationType = .push(),
        completion: (() -> Void)? = nil
    ) {
        // Check whether the given navigation controller is empty/new.
        let newNavigation = coordinator.navigationController.children.isEmpty
        let viewController = newNavigation ? coordinator.navigationController : coordinator.rootViewController

        switch type {
        case .push, .replace:
            coordinator.start(presentationType: startType)
            // No need to push further, it is (should be) already happening in the start method.

        case let .present(presentationType, animated):
            coordinator.navigationController.modalPresentationStyle = presentationType
            coordinator.start(presentationType: startType)

            if let presentedController = navigationController.presentedViewController {
                presentedController.present(viewController, animated: animated)
            } else {
                navigationController.present(viewController, animated: animated, completion: completion)
            }
        }
    }
}
