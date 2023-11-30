//
//  NavigationController.swift
//  PasskeysDemo
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import UIKit

final class NavigationController: UINavigationController {
    private let navigationBarAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.backgroundColor
        appearance.shadowColor = .clear
        appearance.setBackIndicatorImage(UIImage(systemName: "chevron.left"), transitionMaskImage: UIImage(systemName: "chevron.left"))
        return appearance
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setNavigationBarAppearance()
    }
     
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftItemsSupplementBackButton = true
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
}

// MARK: Setup
private extension NavigationController {
    func setNavigationBarAppearance() {
        navigationBar.standardAppearance = navigationBarAppearance
        navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationBar.compactAppearance = navigationBarAppearance
    }
}
