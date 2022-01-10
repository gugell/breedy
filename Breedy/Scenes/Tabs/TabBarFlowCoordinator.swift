//
//  TabBarFlowCoordinator.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit

final class TabBarFlowCoordinator: BaseCoordinator {

    private let wireframe: Wireframe
    var onFinishFlow: Action<Void>?

    init(wireframe: Wireframe) {
        self.wireframe = wireframe
    }

    override func start() {
        let module = TabBarModuleAssembly.assembly()
        (module as? TabViewController)?.navigationDelegate = self
        wireframe.setRootModule(module, hideBar: true)
    }
}

extension TabBarFlowCoordinator: TabNavigationDelegate {
    func didSelect(_ controller: UINavigationController, at index: Int) {
        let selectedFlow = TabBarItemVariant(rawValue: index) ?? .home

        switch selectedFlow {
        case .home:
            runHomeFeedFlow(navigationController: controller)
        case .favorites:
            runFavoritesFlow(navigationController: controller)
        }
    }

    private func runFavoritesFlow(navigationController: UINavigationController) {
        if navigationController.viewControllers.isEmpty == true {
            let wireframe = DefaultWireframe(rootController: navigationController)
            let coordinator = FavoritesFlowCoordinator(wireframe: wireframe)
            coordinator.start()
            addDependency(coordinator)
        }
    }

    private func runHomeFeedFlow(navigationController: UINavigationController) {
        if navigationController.viewControllers.isEmpty == true {
            let wireframe = DefaultWireframe(rootController: navigationController)
            let coordinator = HomeFlowCoordinator(wireframe: wireframe)
            coordinator.start()
            addDependency(coordinator)
        }
    }
}
