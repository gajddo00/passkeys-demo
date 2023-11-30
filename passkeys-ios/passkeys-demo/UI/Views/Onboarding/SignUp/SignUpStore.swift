//
//  SignUpStore.swift
//  PasskeysDemo
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import Foundation
import Combine

@MainActor
final class SignUpStore: Store, ObservableObject, SubscriptionCancellable {
    typealias State = SignUpState
    typealias Action = SignUpAction
        
    // MARK: Public
    @Published private(set) var state: SignUpState = .init()
    @Published var username: String = ""

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
            usernameDidChange(value)
        }
    }
}

// MARK: Private
private extension SignUpStore {
    func initiateSignUp() async {
        do {
            if state.mode == .signup {
                _ = try await authenticationService.singUpWith(username: state.username)
                usernameDidChange(state.username)
            } else {
                let result = try await authenticationService.signInWith(username: state.username)
                if case let .signIn(jwt) = result {
                    // Save JWT to keychain and sign user in
                    logger.debug(jwt)
                }
            }
        } catch {
            logger.debug(error)
        }
    }
    
    func usernameDidChange(_ value: String) {
        if value.isEmpty {
            state = state
                .updating(\.username, with: value)
                .updating(\.mode, with: .signin)
        } else if value.count < Constants.usernameCharacterLimit {
            Task {
                let userExists = await authenticationService.userExists(username: username)
                if userExists {
                    state = state
                        .updating(\.username, with: value)
                        .updating(\.mode, with: .signin)
                } else {
                    state = state
                        .updating(\.username, with: value)
                        .updating(\.mode, with: .signup)
                }
            }
        }
    }
}

// MARK: Events
extension SignUpStore: EventEmitting {
    enum Event { }
    
    var eventPublisher: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: Action
enum SignUpAction {
    case didTapSignUp
    case usernameDidChange(String)
}

// MARK: State
struct SignUpState: StoreState {
    enum Mode {
        case signup, signin
    }
        
    var username: String = ""
    var mode: Mode = .signin
}
