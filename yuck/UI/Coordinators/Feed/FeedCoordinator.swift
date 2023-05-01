//
//  FeedCoordinator.swift
//  Yuck
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import DependencyInjection
import Combine
import UIKit

@MainActor
final class FeedCoordinator {
    let navigationController: UINavigationController
    let container: Container
    var childCoordinators: [Coordinator] = []
    var cancellables: Set<AnyCancellable> = []
    
    private let eventSubject = PassthroughSubject<Event, Never>()
    
    var rootViewController: UIViewController {
        navigationController
    }
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
}

extension FeedCoordinator: NavigationControllerCoordinator {
    func start(presentationType: PresentationType) {
        navigationController.viewControllers = [makeFeedScreen()]
    }
}

// MARK: Events
extension FeedCoordinator: EventEmitting {
    enum Event {
        
    }
    
    var eventPublisher: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: Handle events
extension FeedCoordinator: FeedFactoring {
    func handle(event: FeedStore.Event) {
        
    }
}
