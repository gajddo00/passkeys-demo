//
//  File 2.swift
//  
//
//  Created by Dominika Gajdová on 06.05.2023.
//

import DependencyInjection

enum DIContainer {
    static func registerDependencies(to container: Container) {
        container.autoregister(
            type: JwtServicing.self,
            in: .new,
            initializer: JwtService.init
        )
    }
}
