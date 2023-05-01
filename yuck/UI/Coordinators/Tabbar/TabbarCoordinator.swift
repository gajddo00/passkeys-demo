//
//  TabbarCoordinator.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import UIKit
import Combine
import DependencyInjection

@MainActor
final class TabbarCoordinator {
    let navigationController: UINavigationController
    let container: Container
    var childCoordinators: [Coordinator] = []
    var cancellables: Set<AnyCancellable> = []
    
    private(set) lazy var tabBarController = makeTabBarController()
    private let iconSize: CGFloat = 30
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
}

extension TabbarCoordinator: TabBarControllerCoordinator {
    func start(presentationType: PresentationType) {
        tabBarController.tabBar.itemPositioning = .centered
        tabBarController.tabBar.isTranslucent = true
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        
        tabBarController.viewControllers = [
            makeFeedCoordinator().rootViewController,
            makeCreatePostCoordinator().rootViewController,
            makeUserCoordinator().rootViewController
        ]
        
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)] as [NSAttributedString.Key: Any]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
    }
}

private extension TabbarCoordinator {
    func makeTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()

        tabBarController.tabBar.backgroundImage = UIImage()
        tabBarController.tabBar.shadowImage = UIImage()

        return tabBarController
    }
    
    func makeFeedCoordinator() -> ViewControllerCoordinator {
        let coordinator = FeedCoordinator(
            navigationController: NavigationController(),
            container: container
        )
        
        childCoordinators.append(coordinator)
        coordinator.start()
        
        let item = UITabBarItem(
            title: RString.tabFeed(),
            image: "☕️".image(fontSize: iconSize)?.withRenderingMode(.alwaysOriginal),
            selectedImage: "☕️".image(fontSize: iconSize)?.withRenderingMode(.alwaysOriginal)
        )
        
        coordinator.rootViewController.tabBarItem = item
        
        return coordinator
    }
    
    func makeCreatePostCoordinator() -> ViewControllerCoordinator {
        let coordinator = CreatePostCoordinator(
            navigationController: NavigationController(),
            container: container
        )
        
        childCoordinators.append(coordinator)
        coordinator.start()
        
        let item = UITabBarItem(
            title: nil,
            image: RImage.glassesIcon(),
            selectedImage: RImage.glassesIconSelected()
        )
        
        coordinator.rootViewController.tabBarItem = item
        
        return coordinator
    }
    
    func makeUserCoordinator() -> ViewControllerCoordinator {
        let coordinator = UserCoordinator(
            navigationController: NavigationController(),
            container: container
        )
        
        childCoordinators.append(coordinator)
        coordinator.start()
        
        let item = UITabBarItem(
            title: RString.tabUser(),
            image: "🤡".image(fontSize: iconSize)?.withRenderingMode(.alwaysOriginal),
            selectedImage: "🤡".image(fontSize: iconSize)?.withRenderingMode(.alwaysOriginal)
        )
        
        coordinator.rootViewController.tabBarItem = item
        
        return coordinator
    }
}
