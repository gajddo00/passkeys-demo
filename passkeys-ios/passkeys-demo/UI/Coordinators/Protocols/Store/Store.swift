//
//  Store.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import Combine
import SwiftUI

protocol Store {
    associatedtype State: StoreState
    associatedtype Action

    @MainActor var state: State { get }

    @MainActor func send(action: Action)
}

extension Store {
    func sendToMainActor(action: Action) {
        Task {
            await send(action: action)
        }
    }
    
    @MainActor func binding<T>(for keyPath: KeyPath<State, T>, send handler: @escaping (T) -> Action) -> Binding<T> {
        Binding {
            self.state[keyPath: keyPath]
        } set: { value in
            self.send(action: handler(value))
        }
    }
}

protocol PublishingStore: Store {
    var publisher: AnyPublisher<State, Never> { get }
}

extension PublishingStore {
    var statePublisher: PropertyPublisher<State> {
        PropertyPublisher(publisher: publisher)
    }
}

@dynamicMemberLookup
struct PropertyPublisher<T> {
    let publisher: AnyPublisher<T, Never>
    
    subscript<Value>(dynamicMember member: KeyPath<T, Value>) -> AnyPublisher<Value, Never> {
        publisher
            .map(member)
            .eraseToAnyPublisher()
    }
    
    subscript<Value: Equatable>(dynamicMember member: KeyPath<T, Value>) -> AnyPublisher<Value, Never> {
        publisher
            .map(member)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
