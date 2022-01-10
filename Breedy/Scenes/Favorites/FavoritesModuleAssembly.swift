//
//  FavoritesModuleAssembly.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit

enum FavoritesModuleAssembly {
    static func assembly() -> Presentable {
        let viewController = FavoritesViewController()

        return viewController
    }
}
