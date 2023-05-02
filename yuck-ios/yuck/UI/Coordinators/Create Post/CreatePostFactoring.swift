//
//  CreatePostFactoring.swift
//  Yuck
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import UIKit
import SwiftUI

@MainActor
protocol CreatePostFactoring {
    func makeCreatePostScreen() -> UIViewController
    
    func handle(event: CreatePostStore.Event)
}

extension CreatePostFactoring where Self: ViewControllerCoordinator {
    func makeCreatePostScreen() -> UIViewController {
        let store = resolve(CreatePostStore.self)
        let view = CreatePostScreen(store: store)
        
        store.eventPublisher
            .sink { [weak self] event in
                self?.handle(event: event)
            }
            .store(in: &store.cancellables)
        
        return UIHostingController(rootView: view)
    }
}
