//
//  WelcomeStore.swift
//  Yuck
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import Foundation
import Combine

final class WelcomeStore: Store, ObservableObject, SubscriptionCancellable {
    typealias State = WelcomeState
    typealias Action = WelcomeAction
    
    // MARK: Public
    @Published private(set) var state: WelcomeState = .init()
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: Private
    private var eventSubject = PassthroughSubject<Event, Never>()
    
    func send(action: WelcomeAction) {
        switch action {
        case .didTapWelcome:
            eventSubject.send(.didFinish)
        }
    }
}

// MARK: Events
extension WelcomeStore: EventEmitting {
    enum Event {
        case didFinish
    }
    
    var eventPublisher: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: Actions
enum WelcomeAction {
    case didTapWelcome
}

// MARK: State
struct WelcomeState: StoreState { }
