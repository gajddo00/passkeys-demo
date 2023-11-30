//
//  AppCoordinator.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import DependencyInjection
import UIKit
import Combine

@MainActor
final class AppCoordinator {
    var childCoordinators = [Coordinator]()
    var cancellables: Set<AnyCancellable> = []

    private(set) lazy var activeScenes: [ActiveScene] = []

    let container = Container()
}

// MARK: - AppCoordinating

extension AppCoordinator: AppCoordinating {
    func start(presentationType: PresentationType) {
        assembleDependencyInjectionContainer()
    }
}

// MARK: - Assembly

// Extension is internal to be accessible from test target
extension AppCoordinator {
    func assembleDependencyInjectionContainer() {
        ManagerRegistration.registerDependencies(to: container)
        ServiceRegistration.registerDependencies(to: container)
        StoreRegistration.registerDependencies(to: container)
    }
}

// MARK: Scenes management
extension AppCoordinator {
    func didLaunchScene<Coordinator: SceneCoordinating>(_ scene: UIScene, window: UIWindow) -> Coordinator {
        let coordinator: Coordinator = makeSceneCoordinator(with: window)

        activeScenes.append((scene: scene, coordinatorId: ObjectIdentifier(coordinator)))
        childCoordinators.append(coordinator)

        return coordinator
    }

    func didDisconnectScene(_ scene: UIScene) {
        removeSceneCoordinator(for: scene)
    }
}

// MARK: Coordinators management
private extension AppCoordinator {
    func makeSceneCoordinator<Coordinator: SceneCoordinating>(with window: UIWindow) -> Coordinator {
        let coordinator = Coordinator(window: window, container: container)

        return coordinator
    }

    func removeSceneCoordinator(for scene: UIScene) {
        guard let index = activeScenes.firstIndex(where: { $0.scene == scene }) else {
            return
        }

        let coordinatorId = activeScenes[index].coordinatorId

        // Remove coordinator from child coordinators
        if let index = childCoordinators.firstIndex(where: { ObjectIdentifier($0) == coordinatorId }) {
            childCoordinators.remove(at: index)
        }

        // Remove the scene from the list of active scenes
        activeScenes.remove(at: index)
    }
}
