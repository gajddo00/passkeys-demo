//
//  SceneCoordinating.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import DependencyInjection
import UIKit

protocol SceneCoordinating: Coordinator {
    init(window: UIWindow, container: Container)
}
