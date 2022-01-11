//
//  HomeFlowCoordinator.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit

final class HomeFlowCoordinator: BaseCoordinator {

    private let wireframe: Wireframe
    var onFinishFlow: EmptyAction?

    init(wireframe: Wireframe) {
        self.wireframe = wireframe
    }

    override func start() {
        runInitialFlow()
    }

    private func runInitialFlow() {
        let homeView = HomeModuleAssembly.assembly()
        homeView.onBreedSelected = showBreedDetails
        homeView.onFavoritesSelected = showFavorites
        wireframe.setRootModule(homeView)
    }

    private func showBreedDetails(_ breed: Breed) {
        let module = BreedDetailModuleAssembly.assembly(breed)
        module.onClose = { [weak self] in self?.wireframe.dismissModule() }
        wireframe.presentEmbedded(module)
    }

    private func showFavorites() {
        let coordinator = FavoritesFlowCoordinator(wireframe: wireframe)
        coordinator.onClose = { [weak self, weak coordinator] in
            self?.wireframe.dismissModule()
            self?.removeDependency(coordinator)
        }
        coordinator.start()
        addDependency(coordinator)
    }
}
