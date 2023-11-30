//
//  PresentationType.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import UIKit

public enum PresentationType {
    case push(animated: Bool = true)
    case present(presentationType: UIModalPresentationStyle = .automatic, animated: Bool = true)
    case replace(animated: Bool = false)
}
