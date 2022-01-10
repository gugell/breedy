//
//  TabBarModuleAssembly.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit

enum TabBarModuleAssembly {
    static func assembly() -> Presentable {
        let viewController = TabViewController()
        viewController.tabBar.tintColor = .black
        viewController.tabBar.barTintColor = .lightGray
        viewController.tabBar.isTranslucent = false
        viewController.tabBar.backgroundColor = .white
        viewController.viewControllers = TabBarItemVariant.availableTabs.map {
            let tab = UITabBarItem(title: nil, image: $0.icon, tag: 0)
            let navigationController = UINavigationController()
            navigationController.tabBarItem = tab
            return navigationController
        }

        return viewController
    }
}
