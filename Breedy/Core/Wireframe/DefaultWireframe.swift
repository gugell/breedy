//
//  DefaultWireframe.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit

class DefaultWireframe: NSObject, Wireframe, UINavigationControllerDelegate {

    private weak var rootController: UINavigationController?
    private var completions: [UIViewController : () -> Void]
    private let modalPresentationStyle: UIModalPresentationStyle

    init(rootController: UINavigationController, modalPresentationStyle: UIModalPresentationStyle = .fullScreen) {
        self.rootController = rootController
        self.modalPresentationStyle = modalPresentationStyle
        completions = [:]
        super.init()
        self.rootController?.delegate = self
    }

    func toPresent() -> UIViewController? {
        return rootController
    }

    func present(_ module: Presentable?) {
        present(module, animated: true)
    }

    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        controller.modalPresentationStyle = modalPresentationStyle
        rootController?.present(controller, animated: animated, completion: nil)
    }

    func presentEmbedded(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = modalPresentationStyle
        rootController?.present(navigationController, animated: animated, completion: nil)
    }

    func presentEmbedded(_ module: Presentable?) {
        presentEmbedded(module, animated: true)
    }

    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }

    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }

    func push(_ module: Presentable?) {
        push(module, animated: true)
    }

    func push(_ module: Presentable?, completion: EmptyAction?) {
        push(module, animated: true, hideBottomBar: false, completion: completion)
    }

    func push(_ module: Presentable?, hideBottomBar: Bool) {
        push(module, animated: true, hideBottomBar: hideBottomBar, completion: nil)
    }

    func push(_ module: Presentable?, animated: Bool) {
        push(module, animated: animated, completion: nil)
    }

    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        push(module, animated: animated, hideBottomBar: false, completion: completion)
    }

    func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?) {
        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }

        if let completion = completion {
            completions[controller] = completion
        }
        controller.hidesBottomBarWhenPushed = hideBottomBar
        rootController?.pushViewController(controller, animated: animated)
    }

    func popModule() {
        popModule(animated: true)
    }

    func popModule(animated: Bool) {
        if let controller = rootController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }

    func setRootModule(_ module: Presentable?) {
        setRootModule(module, hideBar: false)
    }

    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
    }

    func popToRootModule(animated: Bool) {
        if let controllers = rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }

    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }

    // MARK: UINavigationControllerDelegate
    public func navigationController(_ navigationController: UINavigationController,
                                     didShow viewController: UIViewController,
                                     animated: Bool) {

        // Ensure the view controller is popping
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(poppedViewController) else {
            return
        }
        runCompletion(for: poppedViewController)
    }

}
