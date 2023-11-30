//
//  OnboardingCoordinator.swift
//  PasskeysDemo
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import DependencyInjection
import Combine
import UIKit

@MainActor
final class AuthenticationCoordinator {
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

extension AuthenticationCoordinator: EventEmitting {
    enum Event {
        case didFinish(Coordinator)
    }
    
    var eventPublisher: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

extension AuthenticationCoordinator: NavigationControllerCoordinator {
    func start(presentationType: PresentationType) {
        navigationController.viewControllers = [makeSignUpScreen()]
    }
}

extension AuthenticationCoordinator: OnboardingFactoring {
    func handle(event: SignUpStore.Event) { }
}
