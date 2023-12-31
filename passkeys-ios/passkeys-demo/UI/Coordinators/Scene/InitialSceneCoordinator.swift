//
//  InitialSceneCoordinator.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import Combine
import DependencyInjection
import UIKit

@MainActor
final class InitialSceneCoordinator {
    let container: Container
    var childCoordinators = [Coordinator]()
    var cancellables: Set<AnyCancellable> = []
    
    private let window: UIWindow

    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
    }
}

// MARK: - SceneCoordinating
extension InitialSceneCoordinator: InitialSceneCoordinating {
    func start(presentationType: PresentationType) {
        let coordinator = makeAuthenticationCoordinator()
        makeKeyAndVisible(coordinator: coordinator)
    }
}

// MARK: Private
private extension InitialSceneCoordinator {
    func makeKeyAndVisible(coordinator: ViewControllerCoordinator) {
        window.rootViewController = coordinator.rootViewController
        window.makeKeyAndVisible()
    }

    func makeAuthenticationCoordinator() -> ViewControllerCoordinator {
        let coordinator = AuthenticationCoordinator(
            navigationController: NavigationController(),
            container: container
        )
        
        coordinator.eventPublisher
            .sink { [weak self] event in
                self?.handle(event: event)
            }
            .store(in: &coordinator.cancellables)
        
        childCoordinators.append(coordinator)
        coordinator.start()
        return coordinator
    }
}

// MARK: - Handle events
private extension InitialSceneCoordinator {
    func handle(event: AuthenticationCoordinator.Event) {
        switch event {
        case let .didFinish(coordinator):
            removeChild(coordinator)
            start(presentationType: .push())
        }
    }
}
