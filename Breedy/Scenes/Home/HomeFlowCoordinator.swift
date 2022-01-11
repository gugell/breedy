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
        wireframe.setRootModule(homeView)
    }

    private func showBreedDetails(_ breed: Breed) {
        let module = BreedDetailModuleAssembly.assembly(breed)
        module.onClose = { [weak self] in self?.wireframe.dismissModule() }

        wireframe.presentEmbedded(module)
    }
}
