//
//  AppCoordinatingProtocol.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

protocol AppCoordinatorContaining {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var coordinator: AppCoordinating! { get }
}
