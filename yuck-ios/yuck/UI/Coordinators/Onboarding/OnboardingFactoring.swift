//
//  OnboardingFactory.swift
//  Yuck
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import UIKit
import SwiftUI

@MainActor
protocol OnboardingFactoring {
    func makeWelcomeScreen() -> UIViewController
    func makeSignUpScreen() -> UIViewController
    
    func handle(event: WelcomeStore.Event)
    func handle(event: SignUpStore.Event)
}

extension OnboardingFactoring where Self: NavigationControllerCoordinator {
    func makeWelcomeScreen() -> UIViewController {
        let store = resolve(WelcomeStore.self)
        let view = WelcomeScreen(store: store)
        
        store.eventPublisher
            .sink { [weak self] event in
                self?.handle(event: event)
            }
            .store(in: &store.cancellables)
        
        return UIHostingController(rootView: view)
    }
    
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
