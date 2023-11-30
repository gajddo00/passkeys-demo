//
//  EventEmitting.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import Combine

protocol EventEmitting {
    associatedtype Event
    
    var eventPublisher: AnyPublisher<Event, Never> { get }
}
