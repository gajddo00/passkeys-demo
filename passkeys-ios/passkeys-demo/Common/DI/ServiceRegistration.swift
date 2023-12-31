//
//  ServiceRegistration.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import DependencyInjection

enum ServiceRegistration {
    static func registerDependencies(to container: Container) {
        container.autoregister(
            type: AuthenticationServicing.self,
            in: .new,
            initializer: AuthenticationService.init
        )
    }
}
