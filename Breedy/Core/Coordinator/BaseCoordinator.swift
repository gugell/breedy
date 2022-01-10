//
//  BaseCoordinator.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import Foundation

class BaseCoordinator: NSObject, Coordinator {

    var childCoordinators: [Coordinator] = []

    func start() {
        start(with: .unknown)
    }

    func start(with option: DeepLinkOption) { }

    // add only unique object
    func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }

    func removeAll() {
        childCoordinators.removeAll()
    }

    func removeDependency(_ coordinator: Coordinator?) {
        guard
        childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }

        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

    func coordinator<T>() -> T? {
        return self.childCoordinators.compactMap { $0 as? T }.first
    }
}
