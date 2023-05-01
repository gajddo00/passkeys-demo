//
//  SubscriptionCancellable.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import Combine

@MainActor
protocol SubscriptionCancellable {
    var cancellables: Set<AnyCancellable> { get }
}
