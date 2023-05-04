//
//  SignUpStore.swift
//  Yuck
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import Foundation
import Combine

final class SignUpStore: Store, ObservableObject, SubscriptionCancellable {
    typealias State = SignUpState
    typealias Action = SignUpAction
        
    // MARK: Public
    @Published private(set) var state: SignUpState = .init()
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: Private
    private let eventSubject = PassthroughSubject<Event, Never>()
    private let authenticationService: AuthenticationServicing
        
    init(authenticationService: AuthenticationServicing) {
        self.authenticationService = authenticationService
    }
    
    func send(action: SignUpAction) {
        switch action {
        case .didTapSignUp:
            Task { await initiateSignUp() }
            
        case let .usernameDidChange(value):
            if value.count < Constants.usernameCharacterLimit {
                state.username = value
            }
            
        case let .emojiDidChange(value):
            state.emoji = value
        }
    }
}

// MARK: Private
private extension SignUpStore {
    func initiateSignUp() async {
        do {
            try await authenticationService.singUpWith(username: state.username)
        } catch {
            logger.debug(error)
        }
    }
}

// MARK: Events
extension SignUpStore: EventEmitting {
    enum Event {
        
    }
    
    var eventPublisher: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: Action
enum SignUpAction {
    case didTapSignUp
    case usernameDidChange(String)
    case emojiDidChange(String)
}

// MARK: State
struct SignUpState: StoreState {
    var username: String = ""
    var emoji: String = ""
}
