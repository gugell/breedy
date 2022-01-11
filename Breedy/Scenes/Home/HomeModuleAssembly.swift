//
//  HomeModuleAssembly.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import Foundation

protocol HomeView: Presentable {
    var onBreedSelected: Action<Breed, Void>? { get set }
}

enum HomeModuleAssembly {
    static func assembly() -> HomeView {
        var viewController = HomeViewController()
        let viewModel = HomeViewModel()
        viewController.bind(to: viewModel)

        return viewController
    }
}
