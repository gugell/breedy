//
//  FavoritesModuleAssembly.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit

protocol FavoritesView: Presentable {
    var onClose: EmptyAction? { get set }
}

enum FavoritesModuleAssembly {
    static func assembly() -> FavoritesView {
        var viewController = FavoritesViewController()
        let viewModel = FavoritesViewModel()
        viewController.bind(to: viewModel)

        return viewController
    }
}
