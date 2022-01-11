//
//  BreedDetailModuleAssembly.swift
//  Breedy
//
//  Created by Ilia Gutu on 11.01.2022.
//

import Foundation

protocol BreedDetailView: Presentable {
    var onClose: EmptyAction? { get set }
}

enum BreedDetailModuleAssembly {
    static func assembly(_ breed: Breed) -> BreedDetailView {
        var viewController = BreedDetailViewController()
        let viewModel = BreedDetailViewModel(breed: breed)
        viewController.bind(to: viewModel)

        return viewController
    }
}
