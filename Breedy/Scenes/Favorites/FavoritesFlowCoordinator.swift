//
//  FavoritesFlowCoordinator.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit

final class FavoritesFlowCoordinator: BaseCoordinator {

    private let wireframe: Wireframe
    var onFinishFlow: EmptyAction?

    init(wireframe: Wireframe) {
        self.wireframe = wireframe
    }

    override func start() {
        runInitialFlow()
    }

    private func runInitialFlow() {
        wireframe.setRootModule(FavoritesModuleAssembly.assembly())
    }
}
