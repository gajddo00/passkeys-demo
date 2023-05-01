//
//  CreatePostStore.swift
//  Yuck
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import Foundation
import Combine

@MainActor
final class CreatePostStore: Store, ObservableObject, SubscriptionCancellable {
    typealias State = CreatePostState
    typealias Action = CreatePostAction
    
    // MARK: Public
    @Published private(set) var state: CreatePostState = .init()
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: Private
    private let eventSubject = PassthroughSubject<Event, Never>()
    
    func send(action: CreatePostAction) {
        
    }
}

// MARK: Events
extension CreatePostStore: EventEmitting {
    enum Event {
        
    }
    
    var eventPublisher: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: Actions
enum CreatePostAction { }

// MARK: State
struct CreatePostState: StoreState { }
