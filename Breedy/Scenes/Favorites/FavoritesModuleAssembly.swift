//
//  FavoritesModuleAssembly.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit

protocol FavoritesView: Presentable { }

enum FavoritesModuleAssembly {
    static func assembly() -> FavoritesView {
        var viewController = FavoritesViewController()
        let viewModel = FavoritesViewModel()
        viewController.bind(to: viewModel)

        return viewController
    }
}
