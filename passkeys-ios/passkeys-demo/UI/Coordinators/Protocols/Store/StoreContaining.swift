//
//  StoreContaining.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

protocol StoreContaining: AnyObject {
    associatedtype ViewStore: Store

    // swiftlint:disable:next implicitly_unwrapped_optional
    var store: ViewStore! { get set }
}
