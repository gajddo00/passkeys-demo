//
//  StoreState.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import Foundation

protocol StoreState {}

extension StoreState {
    func updating<Value>(_ keyPath: WritableKeyPath<Self, Value>, with value: Value) -> Self {
        var copy = self
        copy[keyPath: keyPath] = value
        return copy
    }
}
