//
//  Coordinator.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import DependencyInjection

protocol Coordinator: AnyObject, SubscriptionCancellable {
    var container: Container { get }
    var childCoordinators: [Coordinator] { get set }

    func start(presentationType: PresentationType)
    func removeChild(_ coordinator: Coordinator)
}

// MARK: - Dependency Injection

extension Coordinator {
    func resolve<Service>(_ serviceType: Service.Type) -> Service {
        container.resolve(type: serviceType)
    }

    func resolve<Service, Arg>(_ serviceType: Service.Type, argument: Arg) -> Service {
        container.resolve(type: serviceType, argument: argument)
    }

    func resolve<Service: StoreContaining>(_ serviceType: Service.Type, store: Service.ViewStore) -> Service? {
        let instance = resolve(serviceType)

        instance.store = store

        return instance
    }

    func release(coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}

extension Coordinator {
    /// Warning: Each coordinator must implement this method.
    /// BAD_ACCESS is an indication of missing implementation.
    func start(presentationType: PresentationType = .push()) {
        self.start(presentationType: presentationType)
    }
}

extension Coordinator {
    func removeChild(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }

    func removeLastChild() {
        let index = childCoordinators.count - 1

        if index > 0 {
            childCoordinators.remove(at: index)
        }
    }
}
