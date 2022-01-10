//
//  HomeModuleAssembly.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import Foundation

enum HomeModuleAssembly {
    static func assembly() -> Presentable {
        var viewController = HomeViewController()
        let viewModel = HomeViewModel()
        viewController.bind(to: viewModel)

        return viewController
    }
}
