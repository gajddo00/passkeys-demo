//
//  FeedFactory.swift
//  Yuck
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import UIKit
import SwiftUI

@MainActor
protocol FeedFactoring {
    func makeFeedScreen() -> UIViewController
    
    func handle(event: FeedStore.Event)
}

extension FeedFactoring where Self: ViewControllerCoordinator {
    func makeFeedScreen() -> UIViewController {
        let store = resolve(FeedStore.self)
        let view = FeedScreen(store: store)
        
        store.eventPublisher
            .sink { [weak self] event in
                self?.handle(event: event)
            }
            .store(in: &store.cancellables)
        
        return UIHostingController(rootView: view)
    }
}
