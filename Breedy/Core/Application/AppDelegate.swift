//
//  AppDelegate.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: PluggableApplicationDelegate {

    override var services: [ApplicationService] {
        return [
            ApplicationFlowService()
        ]
    }

    override init() {
        super.init()
        self.window = buildWindow()
    }

    func buildWindow() -> UIWindow {
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController.init()
        return window
    }
}
