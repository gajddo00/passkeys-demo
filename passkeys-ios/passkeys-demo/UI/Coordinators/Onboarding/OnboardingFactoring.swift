//
//  OnboardingFactory.swift
//  PasskeysDemo
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import UIKit
import SwiftUI

@MainActor
protocol OnboardingFactoring {
    func makeSignUpScreen() -> UIViewController
        
    func handle(event: SignUpStore.Event)
}

extension OnboardingFactoring where Self: NavigationControllerCoordinator {
    func makeSignUpScreen() -> UIViewController {
        let store = resolve(SignUpStore.self)
        let view = SignUpScreen(store: store)
        
        store.eventPublisher
            .sink { [weak self] event in
                self?.handle(event: event)
            }
            .store(in: &store.cancellables)
        
        return UIHostingController(rootView: view)
    }
}
