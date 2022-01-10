//
//  TabBarRepresentable.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit

enum TabBarItemVariant: Int, CaseIterable {
    case home
    case favorites

    var icon: UIImage? {
        switch self {
        case .home: return UIImage(systemName: "text.justify.left")
        case .favorites: return UIImage(systemName: "heart.text.square")
        }
    }

    static let availableTabs = [TabBarItemVariant.home, .favorites]
}

protocol TabBarRepresentable: AnyObject {
    var tabBarItemVariant: TabBarItemVariant { get }

    var controller: UIViewController { get }
    func configureTabBarItem()
}

extension TabBarRepresentable where Self: UIViewController {
    func configureTabBarItem() {
        tabBarItem.image = tabBarItemVariant.icon
    }

    var controller: UIViewController {
        return self as UIViewController
    }
}
