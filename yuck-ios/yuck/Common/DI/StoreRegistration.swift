//
//  StoreRegistration.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import DependencyInjection

@MainActor
enum StoreRegistration {
    static func registerDependencies(to container: Container) {
        container.register(in: .new) { _ in
            WelcomeStore()
        }
        
        container.register(in: .new) { _ in
            FeedStore()
        }
        
        container.register(in: .new) { _ in
            CreatePostStore()
        }
        
        container.register(in: .new) { container in
            SignUpStore(authenticationService: container.resolve(type: AuthenticationServicing.self))
        }
    }
}
