//
//  OnboardingCoordinator.swift
//  Yuck
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import DependencyInjection
import Combine
import UIKit

@MainActor
final class OnboardingCoordinator {
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

extension OnboardingCoordinator: EventEmitting {
    enum Event {
        case didFinish(Coordinator)
    }
    
    var eventPublisher: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

extension OnboardingCoordinator: NavigationControllerCoordinator {
    func start(presentationType: PresentationType) {
        navigationController.viewControllers = [makeWelcomeScreen()]
    }
}

extension OnboardingCoordinator: OnboardingFactoring {
    func handle(event: WelcomeStore.Event) {
        switch event {
        case .didFinish:
            // for now
            UserDefaultsProvider.welcomeScreenDisplayed = true
            eventSubject.send(.didFinish(self))
        }
    }
}
