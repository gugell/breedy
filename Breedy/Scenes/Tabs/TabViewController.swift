//
//  TabViewController.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit

public protocol TabNavigationDelegate: UITabBarControllerDelegate {
    func didSelect(_ controller: UINavigationController, at index: Int)
}

final class TabViewController: UITabBarController {

    weak var navigationDelegate: TabNavigationDelegate? {
        didSet {
            selectFirstItem()
        }
    }

    override var selectedIndex: Int {
        didSet {
            didSelectTab(at: selectedIndex)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }

    func didSelectTab(at index: Int) {
        guard let controller = viewControllers?[index] as? UINavigationController else { return
        }
        navigationDelegate?.didSelect(controller, at: index)
    }

    func selectFirstItem() {
        guard let controller = viewControllers?.first as? UINavigationController else { return }
        navigationDelegate?.didSelect(controller, at: 0)
    }
}

extension TabViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        didSelectTab(at: tabBarController.selectedIndex)
    }
}
