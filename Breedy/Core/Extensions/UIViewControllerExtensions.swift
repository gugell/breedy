//
//  UIViewControllerExtensions.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit

extension UIViewController {
    static func mocked(backgroundColor: UIColor = .white, title: String? = nil) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = backgroundColor
        controller.title = title
        return controller
    }
}
