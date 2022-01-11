//
//  FavoritesFlowCoordinator.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit

final class FavoritesFlowCoordinator: BaseCoordinator {

    private let wireframe: Wireframe
    var onClose: EmptyAction?

    init(wireframe: Wireframe) {
        self.wireframe = wireframe
    }

    override func start() {
        runInitialFlow()
    }

    private func runInitialFlow() {
        let module = FavoritesModuleAssembly.assembly()
        module.onClose = onClose
        wireframe.presentEmbedded(module)
    }
}
