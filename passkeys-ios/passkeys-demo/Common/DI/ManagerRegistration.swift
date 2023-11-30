//
//  ManagerRegistration.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import DependencyInjection
import Networking

enum ManagerRegistration {
    static func registerDependencies(to container: Container) {
        container.register(type: APIManaging.self, in: .shared) { _ in
            APIManager()
        }
    }
}
